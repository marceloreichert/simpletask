defmodule SimpletaskWeb.RoomLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Policies.RoomPolicy
  alias Simpletask.Queries.RoomQuery
  alias Simpletask.Schemas.RoomSchema

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    action = socket.assigns.live_action

    case Bodyguard.permit(RoomPolicy, policy_action(action), socket.assigns.current_user) do
      :ok -> {:noreply, apply_action(socket, action, params)}
      {:error, _} -> {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end

  defp policy_action(:index), do: :list_rooms
  defp policy_action(:new), do: :new_room
  defp policy_action(:edit), do: :edit_room

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Sala")
    |> assign(:room, RoomQuery.get_room!(id))
  end

  defp apply_action(socket, :new, _params) do
    user = socket.assigns.current_user

    socket
    |> assign(:page_title, "Nova Sala")
    |> assign(:room, %RoomSchema{user_id: user.id, unit_id: user.unit_id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listagem de Salas")
    |> assign(:room, nil)
    |> stream(:rooms, RoomQuery.list_rooms(socket.assigns.current_user))
  end

  @impl true
  def handle_info({SimpletaskWeb.RoomLive.FormComponent, {:saved, room}}, socket) do
    {:noreply, stream_insert(socket, :rooms, room)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case Bodyguard.permit(RoomPolicy, :delete_room, socket.assigns.current_user) do
      :ok ->
        room = RoomQuery.get_room!(id)
        {:ok, _} = RoomQuery.delete_room(room)
        {:noreply, stream_delete(socket, :rooms, room)}

      {:error, _} ->
        {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end
end
