defmodule SimpletaskWeb.ProfessionalLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.ProfessionalQuery
  alias Simpletask.Schemas.ProfessionalSchema

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     stream(
       socket,
       :professional_collection,
       ProfessionalQuery.list_professional(socket.assigns.current_user)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Professional")
    |> assign(:professional, ProfessionalQuery.get_professional!(id))
  end

  defp apply_action(socket, :new, _params) do
    user = socket.assigns.current_user

    socket
    |> assign(:page_title, "New Professional")
    |> assign(:professional, %ProfessionalSchema{unit_id: user.unit_id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Professional")
    |> assign(:professional, nil)
  end

  @impl true
  def handle_info({SimpletaskWeb.ProfessionalLive.FormComponent, {:saved, professional}}, socket) do
    {:noreply, stream_insert(socket, :professional_collection, professional)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    professional = ProfessionalQuery.get_professional!(id)
    {:ok, _} = ProfessionalQuery.delete_professional(professional)

    {:noreply, stream_delete(socket, :professional_collection, professional)}
  end
end
