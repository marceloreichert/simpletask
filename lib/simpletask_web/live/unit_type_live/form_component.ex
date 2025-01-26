defmodule SimpletaskWeb.UnitTypeLive.FormComponent do
  use SimpletaskWeb, :live_component

  alias Simpletask.UnitTypes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage unit_type records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="unit_type-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Unit type</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{unit_type: unit_type} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(UnitTypes.change_unit_type(unit_type))
     end)}
  end

  @impl true
  def handle_event("validate", %{"unit_type" => unit_type_params}, socket) do
    changeset = UnitTypes.change_unit_type(socket.assigns.unit_type, unit_type_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"unit_type" => unit_type_params}, socket) do
    save_unit_type(socket, socket.assigns.action, unit_type_params)
  end

  defp save_unit_type(socket, :edit, unit_type_params) do
    case UnitTypes.update_unit_type(socket.assigns.unit_type, unit_type_params) do
      {:ok, unit_type} ->
        notify_parent({:saved, unit_type})

        {:noreply,
         socket
         |> put_flash(:info, "Unit type updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_unit_type(socket, :new, unit_type_params) do
    case UnitTypes.create_unit_type(unit_type_params) do
      {:ok, unit_type} ->
        notify_parent({:saved, unit_type})

        {:noreply,
         socket
         |> put_flash(:info, "Unit type created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
