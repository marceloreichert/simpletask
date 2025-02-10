defmodule SimpletaskWeb.UnitLive.Show do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.ModalityQuery
  alias Simpletask.Queries.UnitQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    modality_options = Enum.map(ModalityQuery.list_modalities(), &{&1.name, &1.id})

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:modality_options, modality_options)
     |> assign(:unit, UnitQuery.get_unit!(id))}
  end

  defp page_title(:show), do: "Ver Unidade"
  defp page_title(:edit), do: "Editar Unidade"
end
