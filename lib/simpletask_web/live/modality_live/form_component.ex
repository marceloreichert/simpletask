defmodule SimpletaskWeb.ModalityLive.FormComponent do
  use SimpletaskWeb, :live_component

  alias Simpletask.Queries.ModalityQuery

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle></:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="modality-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input_core field={@form[:name]} type="text" label="Nome" />
        <:actions>
          <.button phx-disable-with="Salvando...">Salvar Modalidade</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{modality: modality} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(ModalityQuery.change_modality(modality))
     end)}
  end

  @impl true
  def handle_event("validate", %{"modality_schema" => modality_params}, socket) do
    changeset = ModalityQuery.change_modality(socket.assigns.modality, modality_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"modality_schema" => modality_params}, socket) do
    save_modality(socket, socket.assigns.action, modality_params)
  end

  defp save_modality(socket, :edit, modality_params) do
    case ModalityQuery.update_modality(socket.assigns.modality, modality_params) do
      {:ok, modality} ->
        notify_parent({:saved, modality})

        {:noreply,
         socket
         |> put_flash(:info, "Modalidade salva com sucesso")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_modality(socket, :new, modality_params) do
    case ModalityQuery.create_modality(modality_params) do
      {:ok, modality} ->
        notify_parent({:saved, modality})

        {:noreply,
         socket
         |> put_flash(:info, "Modalidade criada com sucesso")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
