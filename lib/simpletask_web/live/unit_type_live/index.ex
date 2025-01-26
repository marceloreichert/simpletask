defmodule SimpletaskWeb.UnitTypeLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.UnitTypes
  alias Simpletask.UnitTypes.UnitType

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :unit_types, UnitTypes.list_unit_types())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Unit type")
    |> assign(:unit_type, UnitTypes.get_unit_type!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Unit type")
    |> assign(:unit_type, %UnitType{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Unit types")
    |> assign(:unit_type, nil)
  end

  @impl true
  def handle_info({SimpletaskWeb.UnitTypeLive.FormComponent, {:saved, unit_type}}, socket) do
    {:noreply, stream_insert(socket, :unit_types, unit_type)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    unit_type = UnitTypes.get_unit_type!(id)
    {:ok, _} = UnitTypes.delete_unit_type(unit_type)

    {:noreply, stream_delete(socket, :unit_types, unit_type)}
  end
end
