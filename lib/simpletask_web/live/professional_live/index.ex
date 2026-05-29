defmodule SimpletaskWeb.ProfessionalLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Policies.ProfessionalPolicy
  alias Simpletask.Queries.ProfessionalQuery
  alias Simpletask.Queries.SpecialtyQuery
  alias Simpletask.Schemas.ProfessionalSchema

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :specialty_options, SpecialtyQuery.list_specialty_options(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    action = socket.assigns.live_action

    case Bodyguard.permit(ProfessionalPolicy, policy_action(action), socket.assigns.current_user) do
      :ok -> {:noreply, apply_action(socket, action, params)}
      {:error, _} -> {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end

  defp policy_action(:index), do: :list_professionals
  defp policy_action(:new), do: :new_professional
  defp policy_action(:edit), do: :edit_professional

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Dados do Profissional")
    |> assign(:professional, ProfessionalQuery.get_professional!(id, socket.assigns.current_user))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Novo Profissional")
    |> assign(:professional, %ProfessionalSchema{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lista de Profissionais")
    |> assign(:professional, nil)
    |> stream(:professionals, ProfessionalQuery.list_professionals(socket.assigns.current_user))
  end

  @impl true
  def handle_info({SimpletaskWeb.ProfessionalLive.FormComponent, {:saved, professional}}, socket) do
    {:noreply, stream_insert(socket, :professionals, professional)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case Bodyguard.permit(ProfessionalPolicy, :delete_professional, socket.assigns.current_user) do
      :ok ->
        professional = ProfessionalQuery.get_professional!(id)
        {:ok, _} = ProfessionalQuery.delete_professional(professional)
        {:noreply, stream_delete(socket, :professionals, professional)}

      {:error, _} ->
        {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end
end
