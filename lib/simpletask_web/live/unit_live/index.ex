defmodule SimpletaskWeb.UnitLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Schemas.UnitSchema

  alias Simpletask.Queries.ModalityQuery
  alias Simpletask.Queries.UnitQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :units, UnitQuery.list_units(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Unidade")
    |> assign(:unit, UnitQuery.get_unit!(id))
  end

  defp apply_action(socket, :new, _params) do
    modality_options = Enum.map(ModalityQuery.list_modalities(), &{&1.name, &1.id})

    socket
    |> assign(:page_title, "Nova Unidade")
    |> assign(:modality_options, modality_options)
    |> assign(:unit, %UnitSchema{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listar Unidades")
    |> assign(:unit, nil)
  end

  @impl true
  def handle_info({SimpletaskWeb.UnitLive.FormComponent, {:saved, unit}}, socket) do
    {:noreply, stream_insert(socket, :units, unit)}
  end
end
