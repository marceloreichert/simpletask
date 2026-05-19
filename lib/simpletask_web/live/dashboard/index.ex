defmodule SimpletaskWeb.DashboardLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.ScheduleQuery

  @impl true
  def mount(_params, _session, socket) do
    schedules = ScheduleQuery.list_schedules_today(socket.assigns.current_user)

    {:ok,
     socket
     |> assign(:schedules, schedules)
     |> assign(:today, Date.utc_today())}
  end

  def format_time(nil), do: "--"
  def format_time(%Time{} = t), do: Calendar.strftime(t, "%H:%M")
end
