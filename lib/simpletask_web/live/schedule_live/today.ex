defmodule SimpletaskWeb.ScheduleLive.Today do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.ScheduleQuery

  @impl true
  def mount(_params, _session, socket) do
    schedules = ScheduleQuery.list_schedules_with_available_today(socket.assigns.current_user)

    hi_ids = schedules |> Enum.flat_map(& &1.health_insurance_ids) |> Enum.uniq()
    health_insurances_map = ScheduleQuery.get_health_insurances_by_ids(hi_ids) |> Map.new(&{&1.id, &1})

    all_grouped =
      schedules
      |> Enum.group_by(& &1.professional_id)
      |> Enum.map(fn {_id, scheds} ->
        sorted = Enum.sort_by(scheds, & &1.schedule_date, Date)
        {hd(sorted).professional, sorted}
      end)
      |> Enum.sort_by(fn {prof, scheds} ->
        {hd(scheds).schedule_date, prof.name}
      end)

    {:ok,
     socket
     |> assign(:all_grouped, all_grouped)
     |> assign(:grouped, all_grouped)
     |> assign(:health_insurances_map, health_insurances_map)
     |> assign(:doctor_search, "")
     |> assign(:today, DateTime.now!("America/Sao_Paulo") |> DateTime.to_date())}
  end

  @impl true
  def handle_event("search_doctor", %{"value" => ""}, socket) do
    {:noreply, assign(socket, grouped: socket.assigns.all_grouped, doctor_search: "")}
  end

  def handle_event("search_doctor", %{"value" => term}, socket) do
    term_down = String.downcase(term)

    filtered =
      Enum.filter(socket.assigns.all_grouped, fn {professional, _} ->
        professional.name |> String.downcase() |> String.contains?(term_down)
      end)

    {:noreply, assign(socket, grouped: filtered, doctor_search: term)}
  end

  def format_time(nil), do: "--"
  def format_time(%Time{} = t), do: Calendar.strftime(t, "%H:%M")
end
