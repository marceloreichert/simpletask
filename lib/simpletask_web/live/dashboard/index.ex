defmodule SimpletaskWeb.DashboardLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.ScheduleQuery

  @impl true
  def mount(_params, _session, socket) do
    schedules = ScheduleQuery.list_schedules_today(socket.assigns.current_user)

    {:ok,
     socket
     |> assign(:schedules, schedules)
     |> assign(:today, Date.utc_today())
     |> assign(:patient_search, "")
     |> assign(:search_results, [])}
  end

  @impl true
  def handle_event("search_patient", %{"search" => ""}, socket) do
    {:noreply, assign(socket, patient_search: "", search_results: [])}
  end

  def handle_event("search_patient", %{"search" => term}, socket) do
    results = ScheduleQuery.search_details_by_patient(socket.assigns.current_user, term)
    {:noreply, assign(socket, patient_search: term, search_results: results)}
  end

  def format_time(nil), do: "--"
  def format_time(%Time{} = t), do: Calendar.strftime(t, "%H:%M")
end
