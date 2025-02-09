defmodule SimpletaskWeb.SpecialtyLive.Show do
  use SimpletaskWeb, :live_view

  alias Simpletask.Specialties

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:specialty, Specialties.get_specialty!(id))}
  end

  defp page_title(:show), do: "Show Specialty"
  defp page_title(:edit), do: "Edit Specialty"
end
