defmodule SimpletaskWeb.ScheduleLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.RoomQuery
  alias Simpletask.Queries.ScheduleQuery
  alias Simpletask.Schemas.ScheduleSchema

  @impl true
  def mount(_params, _session, socket) do
    schedules = ScheduleQuery.list_schedules(socket.assigns.current_user)
    professional_options = ScheduleQuery.list_professional_options(socket.assigns.current_user)
    room_options = RoomQuery.list_room_options(socket.assigns.current_user)

    {:ok,
     socket
     |> stream(:schedules, schedules)
     |> assign(:professional_options, professional_options)
     |> assign(:room_options, room_options)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Agenda")
    |> assign(:schedule, ScheduleQuery.get_schedule!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Liberar Nova Agenda")
    |> assign(:schedule, %ScheduleSchema{unit_id: socket.assigns.current_user.unit_id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Agendas")
    |> assign(:schedule, nil)
  end

  @impl true
  def handle_info({SimpletaskWeb.ScheduleLive.FormComponent, {:saved, schedule}}, socket) do
    {:noreply, stream_insert(socket, :schedules, schedule)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    schedule = ScheduleQuery.get_schedule!(id)
    {:ok, _} = ScheduleQuery.delete_schedule(schedule)
    {:noreply, stream_delete(socket, :schedules, schedule)}
  end
end
