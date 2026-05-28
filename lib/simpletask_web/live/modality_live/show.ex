defmodule SimpletaskWeb.ModalityLive.Show do
  use SimpletaskWeb, :live_view

  alias Simpletask.Policies.ModalityPolicy
  alias Simpletask.Queries.ModalityQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    action = socket.assigns.live_action

    case Bodyguard.permit(ModalityPolicy, policy_action(action), socket.assigns.current_user) do
      :ok ->
        {:noreply,
         socket
         |> assign(:page_title, page_title(action))
         |> assign(:modality, ModalityQuery.get_modality!(id))}

      {:error, _} ->
        {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end

  defp policy_action(:show), do: :show_modality
  defp policy_action(:edit), do: :edit_modality

  defp page_title(:show), do: "Ver Modalidade"
  defp page_title(:edit), do: "Editar Modalidade"
end
