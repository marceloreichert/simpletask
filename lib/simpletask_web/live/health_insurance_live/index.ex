defmodule SimpletaskWeb.HealthInsuranceLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Policies.HealthInsurancePolicy
  alias Simpletask.Schemas.HealthInsuranceSchema
  alias Simpletask.Queries.HealthInsuranceQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    action = socket.assigns.live_action

    case Bodyguard.permit(HealthInsurancePolicy, policy_action(action), socket.assigns.current_user) do
      :ok -> {:noreply, apply_action(socket, action, params)}
      {:error, _} -> {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end

  defp policy_action(:index), do: :list_health_insurances
  defp policy_action(:new), do: :new_health_insurance
  defp policy_action(:edit), do: :edit_health_insurance

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Convênio")
    |> assign(:health_insurance, HealthInsuranceQuery.get_health_insurance!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Novo Convênio")
    |> assign(:health_insurance, %HealthInsuranceSchema{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Convênios")
    |> assign(:health_insurance, nil)
    |> stream(:health_insurances, HealthInsuranceQuery.list_health_insurances())
  end

  @impl true
  def handle_info({SimpletaskWeb.HealthInsuranceLive.FormComponent, {:saved, health_insurance}}, socket) do
    {:noreply, stream_insert(socket, :health_insurances, health_insurance)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case Bodyguard.permit(HealthInsurancePolicy, :delete_health_insurance, socket.assigns.current_user) do
      :ok ->
        health_insurance = HealthInsuranceQuery.get_health_insurance!(id)
        {:ok, _} = HealthInsuranceQuery.delete_health_insurance(health_insurance)
        {:noreply, stream_delete(socket, :health_insurances, health_insurance)}

      {:error, _} ->
        {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end
end
