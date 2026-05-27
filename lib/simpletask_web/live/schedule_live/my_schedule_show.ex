defmodule SimpletaskWeb.ScheduleLive.MyScheduleShow do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.ScheduleQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:pending_confirm, nil)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(Simpletask.PubSub, "schedule:#{id}")

    {:noreply,
     socket
     |> assign(:page_title, "Minha Agenda — Atendimento")
     |> assign(:schedule, ScheduleQuery.get_schedule!(id))
     |> assign(:current_time, DateTime.now!("America/Sao_Paulo") |> DateTime.to_time())}
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
  def handle_event("initiate_attendance", %{"id" => id}, socket) do
    if ScheduleQuery.professional_has_in_attendance?(id) do
      {:noreply, put_flash(socket, :error, "Este médico já possui um atendimento em andamento.")}
    else
      {:ok, _} = ScheduleQuery.update_detail_status(id, "in_attendance")
      broadcast_schedule_update(socket)
      {:noreply, push_navigate(socket, to: ~p"/schedules/#{socket.assigns.schedule.id}/my/attend/#{id}")}
    end
  end

  @impl true
  def handle_event("mark_showed_up", %{"id" => id}, socket) do
    {:ok, _} = ScheduleQuery.update_detail_status(id, "showed_up")
    broadcast_schedule_update(socket)
    {:noreply, assign(socket, :schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))}
  end

  @impl true
  def handle_event("execute_confirm", _, socket) do
    %{action: action, id: id} = socket.assigns.pending_confirm
    {:noreply, apply_confirm_action(assign(socket, :pending_confirm, nil), action, id)}
  end

  defp apply_confirm_action(socket, "start_attendance", id) do
    if ScheduleQuery.professional_has_in_attendance?(id) do
      put_flash(socket, :error, "Este médico já possui um atendimento em andamento.")
    else
      {:ok, _} = ScheduleQuery.update_detail_status(id, "in_attendance")
      broadcast_schedule_update(socket)
      push_navigate(socket, to: ~p"/schedules/#{socket.assigns.schedule.id}/my/attend/#{id}")
    end
  end

  defp apply_confirm_action(socket, "attend_detail", id) do
    {:ok, _} = ScheduleQuery.update_detail_status(id, "done")
    broadcast_schedule_update(socket)
    assign(socket, :schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))
  end

  defp apply_confirm_action(socket, "reopen_detail", id) do
    {:ok, _} = ScheduleQuery.update_detail_status(id, "marked")
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

  def format_time(nil), do: "--"
  def format_time(%Time{} = t), do: Calendar.strftime(t, "%H:%M")
end
