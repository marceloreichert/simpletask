defmodule SimpletaskWeb.ProfessionalLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.ProfessionalQuery
  alias Simpletask.Queries.SpecialtyQuery

  alias Simpletask.Schemas.ProfessionalSchema

  @impl true
  def mount(_params, _session, socket) do
    professionals = ProfessionalQuery.list_professionals(socket.assigns.current_user)

    {:ok,
     stream(socket, :professionals, professionals)
     |> assign(:specialty_options, SpecialtyQuery.list_specialty_options())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Dados do Profissional")
    |> assign(:professional, ProfessionalQuery.get_professional!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Novo Profissional")
    |> assign(:professional, %ProfessionalSchema{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lista de Profissionais")
    |> assign(:professionals, nil)
  end

  @impl true
  def handle_info({SimpletaskWeb.ProfessionalLive.FormComponent, {:saved, professional}}, socket) do
    {:noreply, stream_insert(socket, :professionals, professional)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    professional = ProfessionalQuery.get_professional!(id)
    {:ok, _} = ProfessionalQuery.delete_professional(professional)

    {:noreply, stream_delete(socket, :professionals, professional)}
  end
end
