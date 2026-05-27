defmodule Simpletask.Audio.Decoder do
  @moduledoc """
  Decodifica um arquivo de áudio (WebM/OGG com Opus) para um tensor
  Nx float32 16 kHz mono, pronto para o Whisper.

  Pipeline Membrane (dinâmico — demuxer informa faixas via notificação):
    File.Source → Matroska.Demuxer
                       ↓ (notificação :new_track)
                  via_out(Pad.ref(:output, track_id))
                  → Opus.Decoder
                  → SWResample.Converter (f32le 16 kHz mono)
                  → PCMCollector (coleta binário e envia ao caller)

  Retorna {:ok, %Nx.Tensor{}} ou {:error, reason}.
  """

  use Membrane.Pipeline

  require Logger

  alias Membrane.RawAudio

  @target_format %RawAudio{
    sample_format: :f32le,
    sample_rate: 16_000,
    channels: 1
  }

  @timeout_ms 60_000

  # ─── API pública ────────────────────────────────────────────────────────────

  @doc "Decodifica o arquivo no path e retorna {:ok, tensor} ou {:error, reason}."
  def decode(path) when is_binary(path) do
    ref = make_ref()

    # Usa start (sem link) + monitor para detectar crashes sem matar o caller
    {:ok, sup, pipeline} = Membrane.Pipeline.start(__MODULE__, {path, self(), ref})
    mon = Process.monitor(sup)

    receive do
      {^ref, {:ok, pcm_binary}} ->
        Process.demonitor(mon, [:flush])
        Membrane.Pipeline.terminate(pipeline)
        tensor = Nx.from_binary(pcm_binary, :f32)
        {:ok, tensor}

      {^ref, {:error, reason}} ->
        Process.demonitor(mon, [:flush])
        Membrane.Pipeline.terminate(pipeline)
        {:error, reason}

      {:DOWN, ^mon, :process, ^sup, reason} ->
        Logger.error("[Decoder] Pipeline supervisor caiu: #{inspect(reason)}")
        {:error, {:pipeline_down, reason}}
    after
      @timeout_ms ->
        Process.demonitor(mon, [:flush])
        Membrane.Pipeline.terminate(pipeline)
        {:error, :timeout}
    end
  end

  # ─── Pipeline callbacks ─────────────────────────────────────────────────────

  @impl true
  def handle_init(_ctx, {path, caller, ref}) do
    # Inicia apenas source → demuxer.
    # O demuxer vai notificar as faixas dinamicamente.
    spec = [
      child(:source, %Membrane.File.Source{location: path})
      |> child(:demuxer, Membrane.Matroska.Demuxer)
    ]

    {[spec: spec], %{caller: caller, ref: ref}}
  end

  # Faixa Opus encontrada — liga o restante do pipeline dinamicamente
  @impl true
  def handle_child_notification(
        {:new_track, {track_id, %{codec: :opus}}},
        :demuxer,
        _ctx,
        state
      ) do
    Logger.info("[Decoder] Faixa Opus encontrada (track_id=#{track_id}), ligando pipeline...")

    spec = [
      get_child(:demuxer)
      |> via_out(Pad.ref(:output, track_id))
      |> child(:opus_decoder, Membrane.Opus.Decoder)
      |> child(:converter, %Membrane.FFmpeg.SWResample.Converter{
        output_stream_format: @target_format
      })
      |> child(:sink, %Simpletask.Audio.PCMCollector{
        caller: state.caller,
        ref: state.ref
      })
    ]

    {[spec: spec], state}
  end

  # Outras notificações (faixas de vídeo etc.) — ignorar
  @impl true
  def handle_child_notification(notification, element, _ctx, state) do
    Logger.debug("[Decoder] Notificação ignorada de #{inspect(element)}: #{inspect(notification)}")
    {[], state}
  end

  # Quando o sink termina, o PCMCollector já enviou os dados ao caller.
  # Podemos encerrar o pipeline.
  @impl true
  def handle_element_end_of_stream(:sink, _pad, _ctx, state) do
    Logger.info("[Decoder] Pipeline concluído, encerrando...")
    {[terminate: :normal], state}
  end

  @impl true
  def handle_element_end_of_stream(_element, _pad, _ctx, state) do
    {[], state}
  end

  @impl true
  def handle_crash_group_down(_group_name, _ctx, state) do
    Logger.error("[Decoder] Pipeline crashed!")
    send(state.caller, {state.ref, {:error, :pipeline_crashed}})
    {[terminate: :normal], state}
  end
end
