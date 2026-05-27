defmodule SimpletaskWeb.ScheduleLive.FormComponent do
  use SimpletaskWeb, :live_component

  alias Simpletask.Queries.HealthInsuranceQuery
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
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Tipo de Cobrança</label>
          <input type="hidden" name="schedule_schema[health_insurance_ids][]" value="" />
          <div class="flex flex-col gap-2">
            <%= for hi <- @health_insurances do %>
              <label class="flex items-center gap-3 text-sm cursor-pointer">
                <input
                  type="checkbox"
                  name="schedule_schema[health_insurance_ids][]"
                  value={hi.id}
                  checked={to_string(hi.id) in Enum.map(@selected_health_insurance_ids, &to_string/1)}
                  class="rounded border-gray-300"
                />
                <span>{hi.name}</span>
                <%= cond do %>
                  <% String.contains?(String.downcase(hi.name), "unimed") -> %>
                    <img src={~p"/images/unimed-logo-1.png"} alt={hi.name} class="h-5 w-auto" />
                  <% String.contains?(String.downcase(hi.name), "bradesco") -> %>
                    <img src={~p"/images/bradesco-saude-logo-1-1.png"} alt={hi.name} class="h-5 w-auto" />
                  <% hi.logo -> %>
                    <span class="flex h-5 w-5 items-center justify-center [&>svg]:h-full [&>svg]:w-full"><%= raw(hi.logo) %></span>
                  <% true -> %>
                <% end %>
              </label>
            <% end %>
          </div>
        </div>
        <div class="grid grid-cols-3 gap-4">
          <.input_core field={@form[:schedule_date]} type="date" label="Data" />
          <.input_core field={@form[:schedule_time_start]} type="time" label="Início" />
          <.input_core field={@form[:schedule_time_end]} type="time" label="Fim" />
        </div>
        <.input_core
          field={@form[:professional_id]}
          type="select"
          label="Profissional"
          options={@professional_options}
          prompt="Selecione..."
        />
        <.input_core
          field={@form[:room_id]}
          type="select"
          label="Sala de Atendimento"
          options={@room_options}
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
     |> assign(:selected_health_insurance_ids, case schedule.health_insurance_ids do
          [] -> ScheduleQuery.list_health_insurance_options() |> Enum.map(fn {_, id} -> to_string(id) end)
          ids -> ids
        end)
     |> assign(:health_insurance_options, ScheduleQuery.list_health_insurance_options())
     |> assign(:health_insurances, HealthInsuranceQuery.list_health_insurances())
     |> assign_new(:form, fn ->
       to_form(ScheduleQuery.change_schedule(schedule))
     end)}
  end

  @impl true
  def handle_event("validate", %{"schedule_schema" => params}, socket) do
    params = maybe_apply_professional_defaults(params, socket)
    ids = params |> Map.get("health_insurance_ids", []) |> Enum.reject(&(&1 == ""))
    schedule_type = if ids == [], do: "unique", else: "health_insurance"

    params = params
      |> Map.put("health_insurance_ids", ids)
      |> Map.put("schedule_type", schedule_type)
      |> Map.put("unit_id", socket.assigns.schedule.unit_id)
    changeset = ScheduleQuery.change_schedule(socket.assigns.schedule, params)

    {:noreply,
     socket
     |> assign(:selected_professional_id, params["professional_id"])
     |> assign(:selected_health_insurance_ids, ids)
     |> assign(form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"schedule_schema" => params}, socket) do
    ids = params |> Map.get("health_insurance_ids", []) |> Enum.reject(&(&1 == ""))
    schedule_type = if ids == [], do: "unique", else: "health_insurance"
    params = params
      |> Map.put("health_insurance_ids", ids)
      |> Map.put("schedule_type", schedule_type)
      |> Map.put("unit_id", socket.assigns.schedule.unit_id)
    save_schedule(socket, socket.assigns.action, params)
  end

  defp maybe_apply_professional_defaults(params, socket) do
    new_id = params["professional_id"]
    prev_id = socket.assigns.selected_professional_id

    if new_id not in [nil, ""] and new_id != prev_id do
      professional = ProfessionalQuery.get_professional!(new_id)

      params
      |> put_professional_value(
        "schedule_consultation_time",
        professional.schedule_consultation_time
      )
      |> put_professional_value(
        "schedule_time_between_consultation",
        professional.schedule_time_between_consultation
      )
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
