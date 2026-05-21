defmodule SimpletaskWeb.ProfessionalTypeLive.Show do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.ProfessionalTypeQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:professional_type, ProfessionalTypeQuery.get_professional_type!(id))}
  end

  defp page_title(:show), do: "Tipo de Profissional"
  defp page_title(:edit), do: "Editar Tipo de Profissional"
end
