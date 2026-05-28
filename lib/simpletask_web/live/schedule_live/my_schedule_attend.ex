defmodule SimpletaskWeb.ScheduleLive.MyScheduleAttend do
  use SimpletaskWeb, :live_view

  require Logger

  alias Simpletask.Queries.ScheduleQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> allow_upload(:audio,
       accept: :any,
       max_entries: 1,
       max_file_size: 50_000_000,
       auto_upload: true,
       progress: &handle_progress/3
     )
     |> assign(:recording, false)
     |> assign(:transcribing, false)
     |> assign(:transcribe_error, nil)}
  end

  @impl true
  def handle_params(%{"id" => schedule_id, "detail_id" => detail_id}, _, socket) do
    detail = ScheduleQuery.get_detail!(detail_id)

    {:noreply,
     socket
     |> assign(:page_title, "Registrar Atendimento")
     |> assign(:schedule_id, schedule_id)
     |> assign(:detail, detail)
     |> assign(:notes, detail.notes || "")}
  end

  # JS iniciou gravação → atualiza visual
  @impl true
  def handle_event("recording_started", _, socket) do
    Logger.info("[AudioRecorder] gravação iniciada")
    {:noreply, assign(socket, recording: true, transcribe_error: nil)}
  end

  # JS parou a gravação e está fazendo upload → mostra transcrevendo
  @impl true
  def handle_event("recording_stopped", _, socket) do
    Logger.info("[AudioRecorder] gravação parada, aguardando upload...")
    {:noreply, assign(socket, recording: false, transcribing: true, transcribe_error: nil)}
  end

  # Mantém @notes sincronizado com o que o usuário digita (necessário para o upload)
  @impl true
  def handle_event("validate", %{"notes" => notes}, socket) do
    {:noreply, assign(socket, :notes, notes)}
  end

  # JS não conseguiu acessar o microfone
  @impl true
  def handle_event("recording_error", %{"message" => message}, socket) do
    Logger.warning("[AudioRecorder] erro de microfone: #{message}")
    {:noreply, assign(socket, recording: false, transcribe_error: "Microfone: #{message}")}
  end

  defp handle_progress(:audio, entry, socket) do
    Logger.info("[AudioRecorder] upload #{entry.progress}% done?=#{entry.done?}")

    if entry.done? do
      lv_pid = self()

      consume_uploaded_entry(socket, entry, fn %{path: path} ->
        dest = Path.join(System.tmp_dir!(), "audio_#{:erlang.unique_integer([:positive])}")
        File.cp!(path, dest)
        Logger.info("[AudioRecorder] arquivo copiado para #{dest}, iniciando Task...")

        Task.start(fn ->
          Logger.info("[AudioRecorder] Task iniciada, decodificando...")

          result =
            try do
              with {:ok, tensor} <- Simpletask.Audio.Decoder.decode(dest),
                   whisper_result <- Simpletask.Serving.Whisper.run!(tensor),
                   {:ok, text} <- extract_transcription(whisper_result) do
                Logger.info("[AudioRecorder] transcrição ok: #{String.slice(text, 0, 50)}...")
                {:ok, text}
              else
                {:error, reason} ->
                  Logger.error("[AudioRecorder] decodificação falhou: #{inspect(reason)}")
                  {:error, "Decodificação: #{inspect(reason)}"}
              end
            rescue
              e ->
                Logger.error("[AudioRecorder] exceção: #{Exception.message(e)}")
                {:error, Exception.message(e)}
            after
              File.rm(dest)
            end

          send(lv_pid, {:transcription_done, result})
        end)

        {:ok, :async}
      end)

      {:noreply, assign(socket, recording: false, transcribing: true)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:transcription_done, {:ok, text}}, socket) do
    Logger.info("[AudioRecorder] handle_info ok, atualizando notes")
    current = socket.assigns.notes || ""
    sep = if current != "" and not String.ends_with?(current, " ") and not String.ends_with?(current, "\n"), do: " ", else: ""
    new_notes = current <> sep <> String.trim(text)

    {:noreply,
     socket
     |> assign(:transcribing, false)
     |> assign(:notes, new_notes)}
  end

  @impl true
  def handle_info({:transcription_done, {:error, reason}}, socket) do
    {:noreply,
     socket
     |> assign(:transcribing, false)
     |> assign(:transcribe_error, reason)}
  end

  @impl true
  def handle_event("save", %{"notes" => notes}, socket) do
    {:ok, _} = ScheduleQuery.update_detail_notes(socket.assigns.detail.id, notes)

    {:noreply,
     socket
     |> put_flash(:info, "Atendimento iniciado com sucesso")
     |> push_navigate(to: ~p"/schedules/#{socket.assigns.schedule_id}/my")}
  end

  # Extrai o texto da resposta do Whisper — suporta os dois formatos que Bumblebee pode retornar:
  #   %{results: [%{text: "..."}]}  (formato antigo)
  #   %{chunks: [%{text: "..."}]}   (formato novo / streaming)
  defp extract_transcription(%{results: [%{text: text} | _]}),
    do: {:ok, String.trim(text)}

  defp extract_transcription(%{chunks: chunks}) when is_list(chunks) and chunks != [] do
    text =
      chunks
      |> Enum.map(& &1.text)
      |> Enum.join("")
      |> String.trim()

    {:ok, text}
  end

  defp extract_transcription(other) do
    Logger.error("[AudioRecorder] whisper retornou formato inesperado: #{inspect(other)}")
    {:error, "Whisper: formato desconhecido"}
  end

  def format_time(nil), do: "--"
  def format_time(%Time{} = t), do: Calendar.strftime(t, "%H:%M")
end
