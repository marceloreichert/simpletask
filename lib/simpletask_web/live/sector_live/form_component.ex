defmodule SimpletaskWeb.SectorLive.FormComponent do
  use SimpletaskWeb, :live_component

  alias Simpletask.Sectors

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage sector records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="sector-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input_core field={@form[:name]} type="text" label="Name" />
        <.input_core field={@form[:unit_id]} type="text" label="Unit" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Sector</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{sector: sector} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Sectors.change_sector(sector))
     end)}
  end

  @impl true
  def handle_event("validate", %{"sector" => sector_params}, socket) do
    changeset = Sectors.change_sector(socket.assigns.sector, sector_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"sector" => sector_params}, socket) do
    save_sector(socket, socket.assigns.action, sector_params)
  end

  defp save_sector(socket, :edit, sector_params) do
    case Sectors.update_sector(socket.assigns.sector, sector_params) do
      {:ok, sector} ->
        notify_parent({:saved, sector})

        {:noreply,
         socket
         |> put_flash(:info, "Sector updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_sector(socket, :new, sector_params) do
    case Sectors.create_sector(sector_params) do
      {:ok, sector} ->
        notify_parent({:saved, sector})

        {:noreply,
         socket
         |> put_flash(:info, "Sector created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
