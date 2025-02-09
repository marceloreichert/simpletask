defmodule SimpletaskWeb.ProfessionalLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Professionals
  alias Simpletask.Professionals.Professional

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     stream(
       socket,
       :professional_collection,
       Professionals.list_professional(socket.assigns.current_user)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Professional")
    |> assign(:professional, Professionals.get_professional!(id))
  end

  defp apply_action(socket, :new, _params) do
    user = socket.assigns.current_user

    socket
    |> assign(:page_title, "New Professional")
    |> assign(:professional, %Professional{unit_id: user.unit_id})
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
    professional = Professionals.get_professional!(id)
    {:ok, _} = Professionals.delete_professional(professional)

    {:noreply, stream_delete(socket, :professional_collection, professional)}
  end
end
