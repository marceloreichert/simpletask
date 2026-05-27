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
    if connected?(socket), do: Phoenix.PubSub.subscribe(Simpletask.PubSub, "schedule:#{id}")

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:schedule, ScheduleQuery.get_schedule!(id))
     |> assign(:professional_options, ScheduleQuery.list_professional_options(socket.assigns.current_user))
     |> assign(:room_options, RoomQuery.list_room_options(socket.assigns.current_user))
     |> assign(:patient_options, PatientQuery.list_patient_options(socket.assigns.current_user))
     |> assign(:current_time, DateTime.now!("America/Sao_Paulo") |> DateTime.to_time())
     |> assign(:current_date, DateTime.now!("America/Sao_Paulo") |> DateTime.to_date())
     |> then(fn s ->
       schedule = s.assigns.schedule
       hi_map = ScheduleQuery.get_health_insurances_by_ids(schedule.health_insurance_ids) |> Map.new(&{&1.id, &1})
       assign(s, :health_insurances_map, hi_map)
     end)}
  end

  @impl true
  def handle_event("mark_detail", %{"id" => id}, socket) do
    {:noreply, assign(socket, :marking_detail_id, id)}
  end

  @impl true
  def handle_event("confirm_mark", params, socket) do
    id = socket.assigns.marking_detail_id
    attrs = %{patient_id: params["patient_id"]}
    attrs = if hi_id = params["health_insurance_id"], do: Map.put(attrs, :health_insurance_id, hi_id), else: attrs
    {:ok, _} = ScheduleQuery.update_detail_status(id, "marked", attrs)
    broadcast_schedule_update(socket)

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
    broadcast_schedule_update(socket)
    assign(socket, :schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))
  end

  defp apply_confirm_action(socket, "reopen_detail", id) do
    {:ok, _} = ScheduleQuery.update_detail_status(id, "available", %{patient_id: nil})
    broadcast_schedule_update(socket)
    assign(socket, :schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))
  end

  defp apply_confirm_action(socket, "attend_detail", id) do
    {:ok, _} = ScheduleQuery.update_detail_status(id, "attended")
    broadcast_schedule_update(socket)
    assign(socket, :schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))
  end

  defp apply_confirm_action(socket, "start_attendance", id) do
    {:ok, _} = ScheduleQuery.update_detail_status(id, "in_attendance")
    broadcast_schedule_update(socket)
    assign(socket, :schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))
  end

  defp apply_confirm_action(socket, "finalize_attendance", id) do
    {:ok, _} = ScheduleQuery.update_detail_status(id, "done")
    broadcast_schedule_update(socket)
    assign(socket, :schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))
  end

  defp broadcast_schedule_update(socket) do
    Phoenix.PubSub.broadcast(Simpletask.PubSub, "schedule:#{socket.assigns.schedule.id}", :schedule_updated)
  end

  @impl true
  def handle_info(:schedule_updated, socket) do
    {:noreply, assign(socket, :schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))}
  end

  defp page_title(:show), do: "Agenda"
  defp page_title(:edit), do: "Editar Agenda"
end
