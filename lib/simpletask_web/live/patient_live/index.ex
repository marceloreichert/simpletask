defmodule SimpletaskWeb.PatientLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Policies.PatientPolicy
  alias Simpletask.Queries.PatientQuery
  alias Simpletask.Schemas.PatientSchema

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    action = socket.assigns.live_action

    case Bodyguard.permit(PatientPolicy, policy_action(action), socket.assigns.current_user) do
      :ok -> {:noreply, apply_action(socket, action, params)}
      {:error, _} -> {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end

  defp policy_action(:index), do: :list_patients
  defp policy_action(:new), do: :new_patient
  defp policy_action(:edit), do: :edit_patient

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Paciente")
    |> assign(:patient, PatientQuery.get_patient!(id))
  end

  defp apply_action(socket, :new, _params) do
    user = socket.assigns.current_user

    socket
    |> assign(:page_title, "Novo Paciente")
    |> assign(:patient, %PatientSchema{unit_id: user.unit_id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listar Pacientes")
    |> assign(:patient, nil)
    |> stream(:patient_collection, PatientQuery.list_patient(socket.assigns.current_user))
  end

  @impl true
  def handle_info({SimpletaskWeb.PatientLive.FormComponent, {:saved, patient}}, socket) do
    {:noreply, stream_insert(socket, :patient_collection, patient)}
  end
end
