defmodule SimpletaskWeb.SpecialtyLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Schemas.SpecialtySchema
  alias Simpletask.Queries.SpecialtyQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :specialties, SpecialtyQuery.list_specialties())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Specialty")
    |> assign(:specialty, SpecialtyQuery.get_specialty!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Specialty")
    |> assign(:specialty, %SpecialtySchema{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Specialties")
    |> assign(:specialty, nil)
  end

  @impl true
  def handle_info({SimpletaskWeb.SpecialtyLive.FormComponent, {:saved, specialty}}, socket) do
    {:noreply, stream_insert(socket, :specialties, specialty)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    specialty = SpecialtyQuery.get_specialty!(id)
    {:ok, _} = SpecialtyQuery.delete_specialty(specialty)

    {:noreply, stream_delete(socket, :specialties, specialty)}
  end
end
