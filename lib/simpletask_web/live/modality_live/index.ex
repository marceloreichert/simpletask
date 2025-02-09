defmodule SimpletaskWeb.ModalityLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Modalities
  alias Simpletask.Modalities.Modality

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :modalities, Modalities.list_modalities())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Modality")
    |> assign(:modality, Modalities.get_modality!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Modality")
    |> assign(:modality, %Modality{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Modalities")
    |> assign(:modality, nil)
  end

  @impl true
  def handle_info({SimpletaskWeb.ModalityLive.FormComponent, {:saved, modality}}, socket) do
    {:noreply, stream_insert(socket, :modalities, modality)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    modality = Modalities.get_modality!(id)
    {:ok, _} = Modalities.delete_modality(modality)

    {:noreply, stream_delete(socket, :modalities, modality)}
  end
end
