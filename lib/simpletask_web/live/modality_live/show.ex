defmodule SimpletaskWeb.ModalityLive.Show do
  use SimpletaskWeb, :live_view

  alias Simpletask.Modalities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:modality, Modalities.get_modality!(id))}
  end

  defp page_title(:show), do: "Show Modality"
  defp page_title(:edit), do: "Edit Modality"
end
