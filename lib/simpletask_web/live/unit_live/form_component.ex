defmodule SimpletaskWeb.UnitLive.FormComponent do
  use SimpletaskWeb, :live_component

  alias Simpletask.Queries.UnitQuery

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
        id="unit-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input_core field={@form[:name]} type="text" label="Nome" />
        <.input_core field={@form[:document_cnes]} type="text" label="CNES" />
        <.input_core field={@form[:document_cnpj]} type="text" label="CNPJ" />
        <.input_core field={@form[:modality_id]} type="select" label="Modalidade" options={@modality_options} />
        <.input_core field={@form[:address]} type="text" label="Endereço" />
        <.input_core field={@form[:address_number]} type="number" label="Número" />
        <.input_core field={@form[:address_complement]} type="text" label="Complemento" />
        <.input_core field={@form[:address_city]} type="text" label="Cidade" />
        <.input_core field={@form[:address_uf]} type="text" label="UF" />
        <.input_core field={@form[:phone]} type="text" label="Telefone" />
        <.input_core field={@form[:email]} type="text" label="Email" />
        <:actions>
          <.button phx-disable-with="Salvando...">Salvar Unidade</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{unit: unit} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(UnitQuery.change_unit(unit))
     end)}
  end

  @impl true
  def handle_event("validate", %{"unit_schema" => unit_params}, socket) do
    changeset = UnitQuery.change_unit(socket.assigns.unit, unit_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"unit_schema" => unit_params}, socket) do
    save_unit(socket, socket.assigns.action, unit_params)
  end

  defp save_unit(socket, :edit, unit_params) do
    case UnitQuery.update_unit(socket.assigns.unit, unit_params) do
      {:ok, unit} ->
        notify_parent({:saved, unit})

        {:noreply,
         socket
         |> put_flash(:info, "Unidade atualizada com sucesso")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_unit(socket, :new, unit_params) do
    case UnitQuery.create_unit(unit_params) do
      {:ok, unit} ->
        notify_parent({:saved, unit})

        {:noreply,
         socket
         |> put_flash(:info, "Unidade criada com sucesso")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
