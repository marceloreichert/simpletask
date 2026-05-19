defmodule SimpletaskWeb.ScheduleLive.Today do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.ScheduleQuery

  @impl true
  def mount(_params, _session, socket) do
    grouped =
      ScheduleQuery.list_schedules_with_available_today(socket.assigns.current_user)
      |> Enum.group_by(& &1.professional_id)
      |> Enum.map(fn {_id, schedules} ->
        {hd(schedules).professional, schedules}
      end)

    {:ok,
     socket
     |> assign(:grouped, grouped)
     |> assign(:today, Date.utc_today())}
  end

  def format_time(nil), do: "--"
  def format_time(%Time{} = t), do: Calendar.strftime(t, "%H:%M")
end
