defmodule SimpletaskWeb.ScheduleLive.Show do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.PatientQuery
  alias Simpletask.Queries.RoomQuery
  alias Simpletask.Queries.ScheduleQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:marking_detail_id, nil)
     |> assign(:patient_id, nil)
     |> assign(:pending_confirm, nil)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:schedule, ScheduleQuery.get_schedule!(id))
     |> assign(:professional_options, ScheduleQuery.list_professional_options(socket.assigns.current_user))
     |> assign(:room_options, RoomQuery.list_room_options(socket.assigns.current_user))
     |> assign(:patient_options, PatientQuery.list_patient_options(socket.assigns.current_user))}
  end

  @impl true
  def handle_event("mark_detail", %{"id" => id}, socket) do
    {:noreply, assign(socket, :marking_detail_id, id)}
  end

  @impl true
  def handle_event("confirm_mark", %{"patient_id" => patient_id}, socket) do
    id = socket.assigns.marking_detail_id
    {:ok, _} = ScheduleQuery.update_detail_status(id, "marked", %{patient_id: patient_id})

    {:noreply,
     socket
     |> assign(:marking_detail_id, nil)
     |> assign(:schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))}
  end

  @impl true
  def handle_event("close_mark_modal", _, socket) do
    {:noreply, assign(socket, :marking_detail_id, nil)}
  end

  @impl true
  def handle_event("request_confirm", %{"action" => action, "id" => id, "color" => color}, socket) do
    {:noreply, assign(socket, :pending_confirm, %{action: action, id: id, color: color})}
  end

  @impl true
  def handle_event("cancel_confirm", _, socket) do
    {:noreply, assign(socket, :pending_confirm, nil)}
  end

  @impl true
  def handle_event("execute_confirm", _, socket) do
    %{action: action, id: id} = socket.assigns.pending_confirm
    socket = apply_confirm_action(socket, action, id)
    {:noreply, assign(socket, :pending_confirm, nil)}
  end

  defp apply_confirm_action(socket, "cancel_detail", id) do
    {:ok, _} = ScheduleQuery.update_detail_status(id, "cancelled")
    assign(socket, :schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))
  end

  defp apply_confirm_action(socket, "reopen_detail", id) do
    {:ok, _} = ScheduleQuery.update_detail_status(id, "available", %{patient_id: nil})
    assign(socket, :schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))
  end

  defp apply_confirm_action(socket, "attend_detail", id) do
    {:ok, _} = ScheduleQuery.update_detail_status(id, "attended")
    assign(socket, :schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))
  end

  defp apply_confirm_action(socket, "start_attendance", id) do
    {:ok, _} = ScheduleQuery.update_detail_status(id, "in_attendance")
    assign(socket, :schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))
  end

  defp page_title(:show), do: "Agenda"
  defp page_title(:edit), do: "Editar Agenda"
end
