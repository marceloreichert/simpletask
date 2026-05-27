defmodule Simpletask.Audio.PCMCollector do
  @moduledoc """
  Membrane Sink que coleta buffers PCM float32 16 kHz mono e
  envia o binário concatenado para o processo chamador quando o
  stream termina.
  """
  use Membrane.Sink

  def_options caller: [spec: pid(), description: "PID que receberá os dados"],
              ref: [spec: reference(), description: "Referência única da chamada"]

  def_input_pad :input,
    accepted_format: %Membrane.RawAudio{
      sample_format: :f32le,
      sample_rate: 16_000,
      channels: 1
    }

  @impl true
  def handle_init(_ctx, opts) do
    {[], %{caller: opts.caller, ref: opts.ref, chunks: []}}
  end

  @impl true
  def handle_buffer(:input, buffer, _ctx, state) do
    {[], %{state | chunks: [buffer.payload | state.chunks]}}
  end

  @impl true
  def handle_end_of_stream(:input, _ctx, state) do
    pcm = state.chunks |> Enum.reverse() |> IO.iodata_to_binary()
    send(state.caller, {state.ref, {:ok, pcm}})
    {[], state}
  end
end
