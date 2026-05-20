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
    {:noreply,
     socket
     |> assign(:page_title, "Minha Agenda — Atendimento")
     |> assign(:schedule, ScheduleQuery.get_schedule!(id))}
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

  defp apply_confirm_action(socket, "start_attendance", id) do
    {:ok, _} = ScheduleQuery.update_detail_status(id, "in_attendance")
    assign(socket, :schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))
  end

  defp apply_confirm_action(socket, "attend_detail", id) do
    {:ok, _} = ScheduleQuery.update_detail_status(id, "attended")
    assign(socket, :schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))
  end

  defp apply_confirm_action(socket, "reopen_detail", id) do
    {:ok, _} = ScheduleQuery.update_detail_status(id, "marked")
    assign(socket, :schedule, ScheduleQuery.get_schedule!(socket.assigns.schedule.id))
  end

  def format_time(nil), do: "--"
  def format_time(%Time{} = t), do: Calendar.strftime(t, "%H:%M")
end
