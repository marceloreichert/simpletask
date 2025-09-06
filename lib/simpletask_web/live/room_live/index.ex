defmodule SimpletaskWeb.RoomLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.RoomQuery
  alias Simpletask.Schemas.RoomSchema

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :rooms, RoomQuery.list_rooms(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Room")
    |> assign(:room, RoomQuery.get_room!(id))
  end

  defp apply_action(socket, :new, _params) do
    user = socket.assigns.current_user

    socket
    |> assign(:page_title, "New Room")
    |> assign(:room, %RoomSchema{user_id: user.id, unit_id: user.unit_id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Rooms")
    |> assign(:room, nil)
  end

  @impl true
  def handle_info({SimpletaskWeb.RoomLive.FormComponent, {:saved, room}}, socket) do
    {:noreply, stream_insert(socket, :rooms, room)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    room = RoomQuery.get_room!(id)
    {:ok, _} = RoomQuery.delete_room(room)

    {:noreply, stream_delete(socket, :rooms, room)}
  end
end
