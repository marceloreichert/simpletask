defmodule SimpletaskWeb.ScheduleLive.FormComponent do
  use SimpletaskWeb, :live_component

  alias Simpletask.Queries.ProfessionalQuery
  alias Simpletask.Queries.ScheduleQuery

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
        id="schedule-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input_core field={@form[:schedule_date]} type="date" label="Data" />
        <.input_core field={@form[:schedule_time_start]} type="time" label="Início" />
        <.input_core field={@form[:schedule_time_end]} type="time" label="Fim" />
        <.input_core
          field={@form[:room_id]}
          type="select"
          label="Sala de Atendimento"
          options={@room_options}
          prompt="Selecione..."
        />
        <.input_core
          field={@form[:professional_id]}
          type="select"
          label="Profissional"
          options={@professional_options}
          prompt="Selecione..."
        />
        <.input_core
          field={@form[:schedule_consultation_time]}
          type="number"
          label="Tempo de consulta (min)"
        />
        <.input_core
          field={@form[:schedule_time_between_consultation]}
          type="number"
          label="Intervalo entre consultas (min)"
        />
        <:actions>
          <.button phx-disable-with="Salvando...">Salvar</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{schedule: schedule} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:selected_professional_id, schedule.professional_id)
     |> assign_new(:form, fn ->
       to_form(ScheduleQuery.change_schedule(schedule))
     end)}
  end

  @impl true
  def handle_event("validate", %{"schedule_schema" => params}, socket) do
    params = maybe_apply_professional_defaults(params, socket)

    changeset = ScheduleQuery.change_schedule(socket.assigns.schedule, params)

    {:noreply,
     socket
     |> assign(:selected_professional_id, params["professional_id"])
     |> assign(form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"schedule_schema" => params}, socket) do
    save_schedule(socket, socket.assigns.action, params)
  end

  defp maybe_apply_professional_defaults(params, socket) do
    new_id = params["professional_id"]
    prev_id = socket.assigns.selected_professional_id

    if new_id not in [nil, ""] and new_id != prev_id do
      professional = ProfessionalQuery.get_professional!(new_id)

      params
      |> put_professional_value("schedule_consultation_time", professional.schedule_consultation_time)
      |> put_professional_value("schedule_time_between_consultation", professional.schedule_time_between_consultation)
    else
      params
    end
  end

  defp put_professional_value(params, key, value) when not is_nil(value),
    do: Map.put(params, key, to_string(value))

  defp put_professional_value(params, _key, _value), do: params

  defp save_schedule(socket, :edit, params) do
    case ScheduleQuery.update_schedule(socket.assigns.schedule, params) do
      {:ok, schedule} ->
        notify_parent({:saved, schedule})

        {:noreply,
         socket
         |> put_flash(:info, "Agenda atualizada com sucesso")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_schedule(socket, :new, params) do
    case ScheduleQuery.create_schedule(params) do
      {:ok, schedule} ->
        notify_parent({:saved, schedule})

        {:noreply,
         socket
         |> put_flash(:info, "Agenda criada com sucesso")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
