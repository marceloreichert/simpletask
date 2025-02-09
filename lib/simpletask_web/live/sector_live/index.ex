defmodule SimpletaskWeb.SectorLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Sectors
  alias Simpletask.Sectors.Sector

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :sectors, Sectors.list_sectors())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Sector")
    |> assign(:sector, Sectors.get_sector!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Sector")
    |> assign(:sector, %Sector{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sectors")
    |> assign(:sector, nil)
  end

  @impl true
  def handle_info({SimpletaskWeb.SectorLive.FormComponent, {:saved, sector}}, socket) do
    {:noreply, stream_insert(socket, :sectors, sector)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    sector = Sectors.get_sector!(id)
    {:ok, _} = Sectors.delete_sector(sector)

    {:noreply, stream_delete(socket, :sectors, sector)}
  end
end
