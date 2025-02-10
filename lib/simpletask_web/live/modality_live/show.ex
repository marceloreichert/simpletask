defmodule SimpletaskWeb.ModalityLive.Show do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.ModalityQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:modality, ModalityQuery.get_modality!(id))}
  end

  defp page_title(:show), do: "Ver Modalidade"
  defp page_title(:edit), do: "Editar Modalidade"
end
