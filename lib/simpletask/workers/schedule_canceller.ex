defmodule Simpletask.Workers.ScheduleCanceller do
  use GenServer
  require Logger

  alias Simpletask.Queries.ScheduleQuery

  @interval :timer.minutes(15)

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    schedule_next_run()
    {:ok, state}
  end

  @impl true
  def handle_info(:run, state) do
    cancel_available_details()
    schedule_next_run()
    {:noreply, state}
  end

  defp cancel_available_details do
    {count, _} = ScheduleQuery.cancel_past_available_details()
    Logger.info("[ScheduleCanceller] #{count} schedule detail(s) marcado(s) como cancelled")
  end

  defp schedule_next_run do
    Process.send_after(self(), :run, @interval)
  end
end
