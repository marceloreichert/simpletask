defmodule SimpletaskWeb.PatientLive.Show do
  use SimpletaskWeb, :live_view

  alias Simpletask.Policies.PatientPolicy
  alias Simpletask.Queries.PatientQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    action = socket.assigns.live_action

    case Bodyguard.permit(PatientPolicy, policy_action(action), socket.assigns.current_user) do
      :ok ->
        {:noreply,
         socket
         |> assign(:page_title, page_title(action))
         |> assign(:patient, PatientQuery.get_patient!(id))}

      {:error, _} ->
        {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end

  defp policy_action(:show), do: :show_patient
  defp policy_action(:edit), do: :edit_patient

  defp page_title(:show), do: "Ver Paciente"
  defp page_title(:edit), do: "Editar Paciente"
end
