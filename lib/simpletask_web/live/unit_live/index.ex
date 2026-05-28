defmodule SimpletaskWeb.UnitLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Schemas.UnitSchema

  alias Simpletask.Policies.UnitPolicy
  alias Simpletask.Queries.ModalityQuery
  alias Simpletask.Queries.UnitQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    action = socket.assigns.live_action
    policy_action = policy_action(action)

    case Bodyguard.permit(UnitPolicy, policy_action, socket.assigns.current_user) do
      :ok -> {:noreply, apply_action(socket, action, params)}
      {:error, _} -> {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end

  defp policy_action(:index), do: :list_units
  defp policy_action(:new), do: :new_unit
  defp policy_action(:edit), do: :edit_unit

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
    |> stream(:units, UnitQuery.list_units(socket.assigns.current_user))
  end

  @impl true
  def handle_info({SimpletaskWeb.UnitLive.FormComponent, {:saved, unit}}, socket) do
    {:noreply, stream_insert(socket, :units, unit)}
  end
end
