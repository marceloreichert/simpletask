defmodule SimpletaskWeb.ProfessionalTypeLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Schemas.ProfessionalTypeSchema
  alias Simpletask.Queries.ProfessionalTypeQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :professional_types, ProfessionalTypeQuery.list_professional_types())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Tipo de Profissional")
    |> assign(:professional_type, ProfessionalTypeQuery.get_professional_type!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Novo Tipo de Profissional")
    |> assign(:professional_type, %ProfessionalTypeSchema{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Tipos de Profissionais de Saúde")
    |> assign(:professional_type, nil)
  end

  @impl true
  def handle_info({SimpletaskWeb.ProfessionalTypeLive.FormComponent, {:saved, professional_type}}, socket) do
    {:noreply, stream_insert(socket, :professional_types, professional_type)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    professional_type = ProfessionalTypeQuery.get_professional_type!(id)
    {:ok, _} = ProfessionalTypeQuery.delete_professional_type(professional_type)
    {:noreply, stream_delete(socket, :professional_types, professional_type)}
  end
end
