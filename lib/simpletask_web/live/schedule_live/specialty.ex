defmodule SimpletaskWeb.ScheduleLive.Specialty do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.ScheduleQuery

  @impl true
  def mount(_params, _session, socket) do
    grouped =
      ScheduleQuery.list_schedules_with_available_by_specialty(socket.assigns.current_user)
      |> Enum.group_by(& &1.professional.specialty_id)
      |> Enum.map(fn {_id, schedules} ->
        specialty = hd(schedules).professional.specialty

        professionals =
          schedules
          |> Enum.group_by(& &1.professional_id)
          |> Enum.map(fn {_pid, prof_schedules} ->
            sorted = Enum.sort_by(prof_schedules, & &1.schedule_date, Date)
            {hd(sorted).professional, sorted}
          end)
          |> Enum.sort_by(fn {_prof, prof_schedules} ->
            hd(prof_schedules).schedule_date
          end, Date)

        {specialty, professionals}
      end)
      |> Enum.sort_by(fn {specialty, _} -> specialty.name end)

    {:ok,
     socket
     |> assign(:grouped, grouped)
     |> assign(:today, Date.utc_today())}
  end

  def format_time(nil), do: "--"
  def format_time(%Time{} = t), do: Calendar.strftime(t, "%H:%M")
end
