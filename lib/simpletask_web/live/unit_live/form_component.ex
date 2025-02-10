defmodule SimpletaskWeb.UnitLive.FormComponent do
  use SimpletaskWeb, :live_component

  alias Simpletask.Units

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage unit records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="unit-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input_core field={@form[:name]} type="text" label="Name" />
        <.input_core field={@form[:document_cnes]} type="text" label="CNES" />
        <.input_core field={@form[:document_cnpj]} type="text" label="CNPJ" />
        <.input_core field={@form[:modality_id]} type="select" label="Modalidade" options={@modality_options} />
        <.input_core field={@form[:address]} type="text" label="Address" />
        <.input_core field={@form[:address_number]} type="number" label="Address number" />
        <.input_core field={@form[:address_complement]} type="text" label="Address complement" />
        <.input_core field={@form[:address_city]} type="text" label="Address city" />
        <.input_core field={@form[:address_uf]} type="text" label="Address uf" />
        <.input_core field={@form[:phone]} type="text" label="Phone" />
        <.input_core field={@form[:email]} type="text" label="Email" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Unit</.button>
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
       to_form(Units.change_unit(unit))
     end)}
  end

  @impl true
  def handle_event("validate", %{"unit" => unit_params}, socket) do
    changeset = Units.change_unit(socket.assigns.unit, unit_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"unit" => unit_params}, socket) do
    save_unit(socket, socket.assigns.action, unit_params)
  end

  defp save_unit(socket, :edit, unit_params) do
    case Units.update_unit(socket.assigns.unit, unit_params) do
      {:ok, unit} ->
        notify_parent({:saved, unit})

        {:noreply,
         socket
         |> put_flash(:info, "Unit updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_unit(socket, :new, unit_params) do
    case Units.create_unit(unit_params) do
      {:ok, unit} ->
        notify_parent({:saved, unit})

        {:noreply,
         socket
         |> put_flash(:info, "Unit created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
