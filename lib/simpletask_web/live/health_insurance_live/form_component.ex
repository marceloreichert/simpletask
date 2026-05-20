defmodule SimpletaskWeb.HealthInsuranceLive.FormComponent do
  use SimpletaskWeb, :live_component

  alias Simpletask.Queries.HealthInsuranceQuery

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <.simple_form
        for={@form}
        id="health-insurance-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input_core field={@form[:name]} type="text" label="Nome" />
        <:actions>
          <.button phx-disable-with="Salvando...">Salvar</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{health_insurance: health_insurance} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(HealthInsuranceQuery.change_health_insurance(health_insurance))
     end)}
  end

  @impl true
  def handle_event("validate", %{"health_insurance_schema" => params}, socket) do
    changeset = HealthInsuranceQuery.change_health_insurance(socket.assigns.health_insurance, params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"health_insurance_schema" => params}, socket) do
    save(socket, socket.assigns.action, params)
  end

  defp save(socket, :new, params) do
    case HealthInsuranceQuery.create_health_insurance(params) do
      {:ok, health_insurance} ->
        notify_parent({:saved, health_insurance})
        {:noreply, socket |> put_flash(:info, "Convênio criado com sucesso") |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save(socket, :edit, params) do
    case HealthInsuranceQuery.update_health_insurance(socket.assigns.health_insurance, params) do
      {:ok, health_insurance} ->
        notify_parent({:saved, health_insurance})
        {:noreply, socket |> put_flash(:info, "Convênio atualizado com sucesso") |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
