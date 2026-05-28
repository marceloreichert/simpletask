defmodule SimpletaskWeb.ProfessionalTypeLive.Show do
  use SimpletaskWeb, :live_view

  alias Simpletask.Policies.ProfessionalTypePolicy
  alias Simpletask.Queries.ProfessionalTypeQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    action = socket.assigns.live_action

    case Bodyguard.permit(ProfessionalTypePolicy, policy_action(action), socket.assigns.current_user) do
      :ok ->
        {:noreply,
         socket
         |> assign(:page_title, page_title(action))
         |> assign(:professional_type, ProfessionalTypeQuery.get_professional_type!(id))}

      {:error, _} ->
        {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end

  defp policy_action(:show), do: :show_professional_type
  defp policy_action(:edit), do: :edit_professional_type

  defp page_title(:show), do: "Tipo de Profissional"
  defp page_title(:edit), do: "Editar Tipo de Profissional"
end
