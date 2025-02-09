defmodule SimpletaskWeb.ProfessionalLive.Show do
  use SimpletaskWeb, :live_view

  alias Simpletask.Professionals

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:professional, Professionals.get_professional!(id))}
  end

  defp page_title(:show), do: "Show Professional"
  defp page_title(:edit), do: "Edit Professional"
end
