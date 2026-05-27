defmodule Simpletask.Serving.Whisper do
  @moduledoc """
  GenServer que carrega o modelo Whisper de forma assíncrona (handle_continue).

  O `init/1` retorna imediatamente, permitindo que o Phoenix Endpoint suba sem esperar.
  O modelo carrega em segundo plano; chamadas a `run!/1` durante o carregamento
  ficam na fila e são processadas assim que o modelo estiver pronto.
  """

  use GenServer
  require Logger

  @model "openai/whisper-small"

  # ─── API pública ──────────────────────────────────────────────────────────

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Transcreve o áudio no `path` e retorna `%{results: [%{text: text}]}`.
  Bloqueia até o modelo estar pronto (útil na primeira chamada após startup).
  """
  def run!(input) do
    GenServer.call(__MODULE__, {:run, input}, :infinity)
  end

  def ready? do
    GenServer.call(__MODULE__, :ready?)
  end

  # ─── Callbacks ────────────────────────────────────────────────────────────

  @impl true
  def init(_opts) do
    Logger.info("[Whisper] Modelo será carregado em segundo plano...")
    # Retorna imediatamente → supervisor continua subindo os próximos filhos
    {:ok, %{serving: nil}, {:continue, :load_model}}
  end

  @impl true
  def handle_continue(:load_model, state) do
    Logger.info("[Whisper] Carregando #{@model}...")

    {:ok, model_info} = Bumblebee.load_model({:hf, @model})
    {:ok, featurizer} = Bumblebee.load_featurizer({:hf, @model})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, @model})
    {:ok, generation_config} = Bumblebee.load_generation_config({:hf, @model})

    serving =
      Bumblebee.Audio.speech_to_text_whisper(
        model_info,
        featurizer,
        tokenizer,
        generation_config,
        chunk_num_seconds: 30,
        task: :transcribe,
        language: "pt"
      )

    Logger.info("[Whisper] Modelo pronto!")
    # Guarda o struct — Nx.Serving.run/2 com struct roda inline (sem processo separado)
    {:noreply, %{state | serving: serving}}
  end

  @impl true
  def handle_call(:ready?, _from, state) do
    {:reply, state.serving != nil, state}
  end

  @impl true
  def handle_call({:run, input}, _from, %{serving: serving} = state) when not is_nil(serving) do
    # Roda a inferência inline no processo do GenServer.
    # Captura exceções para não derrubar o GenServer em caso de arquivo inválido ou ffmpeg ausente.
    result =
      try do
        Nx.Serving.run(serving, input)
      rescue
        e ->
          Logger.error("[Whisper] Falha na transcrição: #{Exception.message(e)}")
          {:error, Exception.message(e)}
      end

    {:reply, result, state}
  end

  @impl true
  def handle_call({:run, _input}, _from, %{serving: nil} = state) do
    {:reply, {:error, :not_ready}, state}
  end
end
