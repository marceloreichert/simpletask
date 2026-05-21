defmodule SimpletaskWeb.ProfessionalTypeLive.FormComponent do
  use SimpletaskWeb, :live_component

  alias Simpletask.Queries.ProfessionalTypeQuery

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle></:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="professional-type-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input_core field={@form[:name]} type="text" label="Nome" />
        <.input_core field={@form[:description]} type="text" label="Descrição" />
        <:actions>
          <.button phx-disable-with="Salvando...">Salvar</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{professional_type: professional_type} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(ProfessionalTypeQuery.change_professional_type(professional_type))
     end)}
  end

  @impl true
  def handle_event("validate", %{"professional_type_schema" => params}, socket) do
    changeset = ProfessionalTypeQuery.change_professional_type(socket.assigns.professional_type, params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"professional_type_schema" => params}, socket) do
    save(socket, socket.assigns.action, params)
  end

  defp save(socket, :edit, params) do
    case ProfessionalTypeQuery.update_professional_type(socket.assigns.professional_type, params) do
      {:ok, professional_type} ->
        notify_parent({:saved, professional_type})

        {:noreply,
         socket
         |> put_flash(:info, "Tipo de profissional atualizado com sucesso")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save(socket, :new, params) do
    case ProfessionalTypeQuery.create_professional_type(params) do
      {:ok, professional_type} ->
        notify_parent({:saved, professional_type})

        {:noreply,
         socket
         |> put_flash(:info, "Tipo de profissional criado com sucesso")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
