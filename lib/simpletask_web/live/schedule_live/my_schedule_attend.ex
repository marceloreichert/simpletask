defmodule SimpletaskWeb.ScheduleLive.MyScheduleAttend do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.ScheduleQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => schedule_id, "detail_id" => detail_id}, _, socket) do
    detail = ScheduleQuery.get_detail!(detail_id)

    {:noreply,
     socket
     |> assign(:page_title, "Registrar Atendimento")
     |> assign(:schedule_id, schedule_id)
     |> assign(:detail, detail)
     |> assign(:notes, detail.notes || "")}
  end

  @impl true
  def handle_event("save", %{"notes" => notes}, socket) do
    {:ok, _} = ScheduleQuery.update_detail_notes(socket.assigns.detail.id, notes)

    {:noreply,
     socket
     |> put_flash(:info, "Atendimento iniciado com sucesso")
     |> push_navigate(to: ~p"/schedules/#{socket.assigns.schedule_id}/my")}
  end

  def format_time(nil), do: "--"
  def format_time(%Time{} = t), do: Calendar.strftime(t, "%H:%M")
end
