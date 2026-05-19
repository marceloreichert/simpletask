defmodule SimpletaskWeb.SpecialtyLive.FormComponent do
  use SimpletaskWeb, :live_component

  alias Simpletask.Queries.SpecialtyQuery

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage specialty records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="specialty-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input_core field={@form[:name]} type="text" label="Name" />
        <.input_core field={@form[:description]} type="text" label="Descrição" />
        <.input_core field={@form[:cbo_number]} type="text" label="CBO" />
        <:actions>
          <.button phx-disable-with="Salvando...">Salvar Especialidade</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{specialty: specialty} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(SpecialtyQuery.change_specialty(specialty))
     end)}
  end

  @impl true
  def handle_event("validate", %{"specialty_schema" => specialty_params}, socket) do
    changeset = SpecialtyQuery.change_specialty(socket.assigns.specialty, specialty_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"specialty_schema" => specialty_params}, socket) do
    save_specialty(socket, socket.assigns.action, specialty_params)
  end

  defp save_specialty(socket, :edit, specialty_params) do
    case SpecialtyQuery.update_specialty(socket.assigns.specialty, specialty_params) do
      {:ok, specialty} ->
        notify_parent({:saved, specialty})

        {:noreply,
         socket
         |> put_flash(:info, "Especialidade atualizada com sucesso")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_specialty(socket, :new, specialty_params) do
    case SpecialtyQuery.create_specialty(specialty_params) do
      {:ok, specialty} ->
        notify_parent({:saved, specialty})

        {:noreply,
         socket
         |> put_flash(:info, "Especialidade criada com sucesso")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
