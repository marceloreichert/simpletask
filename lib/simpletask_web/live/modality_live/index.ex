defmodule SimpletaskWeb.ModalityLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Policies.ModalityPolicy
  alias Simpletask.Queries.ModalityQuery
  alias Simpletask.Schemas.ModalitySchema

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    action = socket.assigns.live_action

    case Bodyguard.permit(ModalityPolicy, policy_action(action), socket.assigns.current_user) do
      :ok -> {:noreply, apply_action(socket, action, params)}
      {:error, _} -> {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end

  defp policy_action(:index), do: :list_modalities
  defp policy_action(:new), do: :new_modality
  defp policy_action(:edit), do: :edit_modality

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
    |> stream(:modalities, ModalityQuery.list_modalities())
  end

  @impl true
  def handle_info({SimpletaskWeb.ModalityLive.FormComponent, {:saved, modality}}, socket) do
    {:noreply, stream_insert(socket, :modalities, modality)}
  end
end
