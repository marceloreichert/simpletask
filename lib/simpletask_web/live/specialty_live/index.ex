defmodule SimpletaskWeb.SpecialtyLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Policies.SpecialtyPolicy
  alias Simpletask.Schemas.SpecialtySchema
  alias Simpletask.Queries.SpecialtyQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    action = socket.assigns.live_action

    case Bodyguard.permit(SpecialtyPolicy, policy_action(action), socket.assigns.current_user) do
      :ok -> {:noreply, apply_action(socket, action, params)}
      {:error, _} -> {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end

  defp policy_action(:index), do: :list_specialties
  defp policy_action(:new), do: :new_specialty
  defp policy_action(:edit), do: :edit_specialty

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Especialidade")
    |> assign(:specialty, SpecialtyQuery.get_specialty!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Nova Especialidade")
    |> assign(:specialty, %SpecialtySchema{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lista de Especialidades")
    |> assign(:specialty, nil)
    |> stream(:specialties, SpecialtyQuery.list_specialties())
  end

  @impl true
  def handle_info({SimpletaskWeb.SpecialtyLive.FormComponent, {:saved, specialty}}, socket) do
    {:noreply, stream_insert(socket, :specialties, specialty)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case Bodyguard.permit(SpecialtyPolicy, :delete_specialty, socket.assigns.current_user) do
      :ok ->
        specialty = SpecialtyQuery.get_specialty!(id)
        {:ok, _} = SpecialtyQuery.delete_specialty(specialty)
        {:noreply, stream_delete(socket, :specialties, specialty)}

      {:error, _} ->
        {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end
end
