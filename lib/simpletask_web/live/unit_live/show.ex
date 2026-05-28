defmodule SimpletaskWeb.UnitLive.Show do
  use SimpletaskWeb, :live_view

  alias Simpletask.Policies.UnitPolicy
  alias Simpletask.Queries.ModalityQuery
  alias Simpletask.Queries.UnitQuery

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    action = socket.assigns.live_action
    policy_action = policy_action(action)

    case Bodyguard.permit(UnitPolicy, policy_action, socket.assigns.current_user) do
      :ok ->
        modality_options = Enum.map(ModalityQuery.list_modalities(), &{&1.name, &1.id})

        {:noreply,
         socket
         |> assign(:page_title, page_title(action))
         |> assign(:modality_options, modality_options)
         |> assign(:unit, UnitQuery.get_unit!(id))}

      {:error, _} ->
        {:noreply, push_navigate(socket, to: ~p"/unauthorized")}
    end
  end

  defp policy_action(:show), do: :show_unit
  defp policy_action(:edit), do: :edit_unit

  defp page_title(:show), do: "Ver Unidade"
  defp page_title(:edit), do: "Editar Unidade"
end
