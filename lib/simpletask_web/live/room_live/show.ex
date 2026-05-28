defmodule SimpletaskWeb.RoomLive.Show do
  use SimpletaskWeb, :live_view

  alias Simpletask.Policies.RoomPolicy
  alias Simpletask.Queries.RoomQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    action = socket.assigns.live_action

    case Bodyguard.permit(RoomPolicy, policy_action(action), socket.assigns.current_user) do
      :ok ->
        {:noreply,
         socket
         |> assign(:page_title, page_title(action))
         |> assign(:room, RoomQuery.get_room!(id))}

      {:error, _} ->
        {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end

  defp policy_action(:show), do: :show_room
  defp policy_action(:edit), do: :edit_room

  defp page_title(:show), do: "Ver Sala"
  defp page_title(:edit), do: "Editar Sala"
end
