defmodule SimpletaskWeb.ScheduleLive.MySchedule do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.ScheduleQuery

  @impl true
  def mount(_params, _session, socket) do
    schedules = ScheduleQuery.list_my_schedules(socket.assigns.current_user)

    {:ok,
     socket
     |> assign(:schedules, schedules)
     |> assign(:today, DateTime.now!("America/Sao_Paulo") |> DateTime.to_date())}
  end

  def format_time(nil), do: "--"
  def format_time(%Time{} = t), do: Calendar.strftime(t, "%H:%M")
end
