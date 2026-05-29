defmodule SimpletaskWeb.SpecialtyLive.Show do
  use SimpletaskWeb, :live_view

  alias Simpletask.Policies.SpecialtyPolicy
  alias Simpletask.Queries.SpecialtyQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    action = socket.assigns.live_action

    case Bodyguard.permit(SpecialtyPolicy, policy_action(action), socket.assigns.current_user) do
      :ok ->
        {:noreply,
         socket
         |> assign(:page_title, page_title(action))
         |> assign(:specialty, SpecialtyQuery.get_specialty!(id, socket.assigns.current_user))}

      {:error, _} ->
        {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end

  defp policy_action(:show), do: :show_specialty
  defp policy_action(:edit), do: :edit_specialty

  defp page_title(:show), do: "Ver Especialidade"
  defp page_title(:edit), do: "Editar Especialidade"
end
