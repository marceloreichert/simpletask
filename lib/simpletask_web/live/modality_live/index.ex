defmodule SimpletaskWeb.ModalityLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.ModalityQuery
  alias Simpletask.Schemas.ModalitySchema

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :modalities, ModalityQuery.list_modalities())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Modalidade")
    |> assign(:modality, ModalityQuery.get_modality!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Inserir Modalidade")
    |> assign(:modality, %ModalitySchema{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listar Modalidades")
    |> assign(:modality, nil)
  end

  @impl true
  def handle_info({SimpletaskWeb.ModalityLive.FormComponent, {:saved, modality}}, socket) do
    {:noreply, stream_insert(socket, :modalities, modality)}
  end
end
