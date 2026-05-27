// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

// ---------------------------------------------------------------------------
// Hook: AudioRecorder
//
// JS opera o MediaRecorder e avisa o LiveView via pushEvent.
// LiveView controla o estado visual (@recording, @transcribing, @transcribe_error).
// Sem phx-click no botão — evita interferência entre phx-click e addEventListener.
//
// Fluxo:
//   clique → addEventListener → getUserMedia → mediaRecorder.start()
//          → pushEvent("recording_started") → @recording = true → botão "Parar"
//   clique → addEventListener → mediaRecorder.stop() → onstop
//          → pushEvent("recording_stopped") → @transcribing = true → spinner
//          → this.upload("audio", [file]) → handle_progress → Task
//          → Membrane + Whisper → handle_info
//          → push_event("append_transcription") → textarea.value += text
// ---------------------------------------------------------------------------
let Hooks = {}

Hooks.AudioRecorder = {
  mounted() {
    this.mediaRecorder = null
    this.audioChunks = []
    this.stream = null
    this.isRecording = false

    const btn = this.el
    const getTextarea = () => document.getElementById(btn.dataset.target)

    console.log("[AudioRecorder] mounted, target:", btn.dataset.target)

    btn.addEventListener("click", async () => {
      console.log("[AudioRecorder] click! isRecording:", this.isRecording)

      if (this.isRecording) {
        // ── Parar ────────────────────────────────────────────────────────────
        // NÃO enviamos pushEvent aqui — qualquer re-render do servidor
        // durante o upload recria o live_file_input e cancela o upload.
        // O handle_progress (server) muda o estado quando o upload termina.
        console.log("[AudioRecorder] parando gravação...")
        this.isRecording = false
        this.mediaRecorder?.stop()

      } else {
        // ── Gravar ───────────────────────────────────────────────────────────
        console.log("[AudioRecorder] pedindo microfone...")
        try {
          const preferredMime = ["audio/webm;codecs=opus", "audio/webm", "audio/ogg;codecs=opus"]
            .find(t => MediaRecorder.isTypeSupported(t)) || ""

          this.stream = await navigator.mediaDevices.getUserMedia({ audio: true })
          console.log("[AudioRecorder] microfone obtido")

          this.audioChunks = []
          this.mediaRecorder = new MediaRecorder(
            this.stream,
            preferredMime ? { mimeType: preferredMime } : {}
          )

          this.mediaRecorder.ondataavailable = (e) => {
            if (e.data.size > 0) this.audioChunks.push(e.data)
          }

          this.mediaRecorder.onstop = () => {
            console.log("[AudioRecorder] onstop — chunks:", this.audioChunks.length)
            this.stream.getTracks().forEach(t => t.stop())

            const mimeType = this.mediaRecorder.mimeType || "audio/webm"
            const baseType = mimeType.split(";")[0].trim()
            const ext = { "audio/webm": "webm", "audio/ogg": "oga",
                          "audio/mp4": "mp4", "audio/mpeg": "mp3" }[baseType] || "webm"

            const blob = new Blob(this.audioChunks, { type: baseType })
            const file = new File([blob], `recording.${ext}`, { type: baseType })

            console.log(`[AudioRecorder] upload: ${file.name} (${file.size} bytes)`)
            this.upload("audio", [file])
            console.log("[AudioRecorder] this.upload chamado")
          }

          this.mediaRecorder.start()
          this.isRecording = true
          this.pushEvent("recording_started", {})
          console.log("[AudioRecorder] gravação iniciada, mimeType:", this.mediaRecorder.mimeType)

        } catch (err) {
          console.error("[AudioRecorder] erro:", err.name, err.message)
          this.isRecording = false
          this.pushEvent("recording_error", { message: err.message })
        }
      }
    })

    // Transcrição concluída → insere no textarea sem re-renderizar o campo
    this.handleEvent("append_transcription", ({ text }) => {
      console.log("[AudioRecorder] append_transcription recebido:", text.slice(0, 50))
      const ta = getTextarea()
      if (ta) {
        const sep = ta.value && !ta.value.endsWith(" ") && !ta.value.endsWith("\n") ? " " : ""
        ta.value += sep + text
        ta.dispatchEvent(new Event("input", { bubbles: true }))
      } else {
        console.warn("[AudioRecorder] textarea não encontrado:", btn.dataset.target)
      }
    })
  },

  destroyed() {
    console.log("[AudioRecorder] destroyed")
    this.isRecording = false
    this.mediaRecorder?.stop()
    this.stream?.getTracks().forEach(t => t.stop())
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: Hooks
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket


// Allows to execute JS commands from the server
window.addEventListener("phx:js-exec", ({detail}) => {
  document.querySelectorAll(detail.to).forEach(el => {
    liveSocket.execJS(el, el.getAttribute(detail.attr))
  })
})
