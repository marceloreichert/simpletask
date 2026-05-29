defmodule SimpletaskWeb.ProfessionalLive.Show do
  use SimpletaskWeb, :live_view

  alias Simpletask.Policies.ProfessionalPolicy
  alias Simpletask.Queries.ProfessionalQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    action = socket.assigns.live_action

    case Bodyguard.permit(ProfessionalPolicy, policy_action(action), socket.assigns.current_user) do
      :ok ->
        {:noreply,
         socket
         |> assign(:page_title, page_title(action))
         |> assign(:professional, ProfessionalQuery.get_professional!(id, socket.assigns.current_user))}

      {:error, _} ->
        {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end

  defp policy_action(:show), do: :show_professional
  defp policy_action(:edit), do: :edit_professional

  defp page_title(:show), do: "Ver Profissional"
  defp page_title(:edit), do: "Editar Profissional"
end
