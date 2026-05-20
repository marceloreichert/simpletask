defmodule Simpletask.Queries.ScheduleQuery do
  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Simpletask.Repo
  alias Simpletask.Schemas.ScheduleSchema
  alias Simpletask.Schemas.ScheduleDetailSchema

  def list_my_schedules(%{professional_id: nil}), do: []
  def list_my_schedules(%{professional_id: professional_id}) do
    today = Date.utc_today()

    from(s in ScheduleSchema,
      join: p in assoc(s, :professional),
      join: sp in assoc(p, :specialty),
      where: s.schedule_date >= ^today and p.id == ^professional_id,
      order_by: [s.schedule_date, s.schedule_time_start],
      preload: [professional: {p, specialty: sp}]
    )
    |> Repo.all()
  end

  def list_schedules_with_available_by_specialty(%{unit_id: unit_id} = _user) do
    today = Date.utc_today()

    from(s in ScheduleSchema,
      join: p in assoc(s, :professional),
      join: sp in assoc(p, :specialty),
      where: s.schedule_date >= ^today and p.unit_id == ^unit_id,
      where:
        fragment(
          "EXISTS (SELECT 1 FROM schedule_details d WHERE d.schedule_id = ? AND d.status = 'available')",
          s.id
        ),
      order_by: [sp.name, s.schedule_date, s.schedule_time_start],
      preload: [professional: {p, specialty: sp}]
    )
    |> Repo.all()
  end

  def list_schedules_with_available_today(%{unit_id: unit_id} = _user) do
    today = Date.utc_today()

    from(s in ScheduleSchema,
      join: p in assoc(s, :professional),
      where: s.schedule_date >= ^today and p.unit_id == ^unit_id,
      where:
        fragment(
          "EXISTS (SELECT 1 FROM schedule_details d WHERE d.schedule_id = ? AND d.status = 'available')",
          s.id
        ),
      order_by: [s.schedule_date, s.schedule_time_start],
      preload: [professional: :specialty]
    )
    |> Repo.all()
  end

  def search_details_by_patient(%{unit_id: unit_id} = _user, search) do
    term = "%#{search}%"

    from(d in ScheduleDetailSchema,
      join: s in assoc(d, :schedule),
      join: p in assoc(s, :professional),
      join: sp in assoc(p, :specialty),
      join: pat in assoc(d, :patient),
      where: p.unit_id == ^unit_id,
      where: ilike(pat.name, ^term),
      order_by: [s.schedule_date, d.schedule_time],
      preload: [schedule: {s, professional: {p, specialty: sp}}, patient: pat]
    )
    |> Repo.all()
  end

  def list_details_today(%{unit_id: unit_id} = _user) do
    today = Date.utc_today()

    from(d in ScheduleDetailSchema,
      join: s in assoc(d, :schedule),
      join: p in assoc(s, :professional),
      where: s.schedule_date == ^today and p.unit_id == ^unit_id,
      order_by: [d.schedule_time],
      preload: [schedule: {s, professional: p}, patient: []]
    )
    |> Repo.all()
  end

  def list_schedules_today(%{unit_id: unit_id} = _user) do
    today = Date.utc_today()

    ScheduleSchema
    |> join(:inner, [s], p in assoc(s, :professional))
    |> where([s, p], s.schedule_date == ^today and p.unit_id == ^unit_id)
    |> order_by([s], s.schedule_time_start)
    |> Repo.all()
    |> Repo.preload(professional: :specialty)
  end

  def list_schedules(%{unit_id: unit_id} = _user) do
    ScheduleSchema
    |> join(:inner, [s], p in assoc(s, :professional))
    |> where([s, p], p.unit_id == ^unit_id)
    |> Repo.all()
    |> Repo.preload(professional: :specialty)
  end

  def list_health_insurance_options do
    alias Simpletask.Schemas.HealthInsuranceSchema

    from(h in HealthInsuranceSchema, order_by: h.name, select: {h.name, h.id})
    |> Repo.all()
  end

  def list_professional_options(%{unit_id: unit_id} = _user) do
    alias Simpletask.Schemas.SpecialtySchema

    from(p in Simpletask.Schemas.ProfessionalSchema,
      join: sp in SpecialtySchema,
      on: p.specialty_id == sp.id,
      where: p.unit_id == ^unit_id and sp.scheduling_allowed == true,
      select: {p.name, p.id}
    )
    |> Repo.all()
  end

  def get_schedule!(id),
    do:
      Repo.get!(ScheduleSchema, id)
      |> Repo.preload([
        :room,
        :health_insurance,
        schedule_details: {from(d in ScheduleDetailSchema, order_by: d.schedule_time), [:patient]},
        professional: :specialty
      ])

  def create_schedule(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:schedule, ScheduleSchema.changeset(%ScheduleSchema{}, attrs))
    |> Multi.run(:details, fn _repo, %{schedule: schedule} ->
      slots = generate_time_slots(
        schedule.schedule_time_start,
        schedule.schedule_time_end,
        schedule.schedule_consultation_time || 30,
        schedule.schedule_time_between_consultation || 0
      )

      details =
        Enum.map(slots, fn slot_time ->
          %ScheduleDetailSchema{}
          |> ScheduleDetailSchema.changeset(%{schedule_id: schedule.id, schedule_time: slot_time, status: "available"})
          |> Repo.insert!()
        end)

      {:ok, details}
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{schedule: schedule}} -> {:ok, schedule}
      {:error, :schedule, changeset, _} -> {:error, changeset}
      {:error, :details, reason, _} -> {:error, reason}
    end
  end

  defp generate_time_slots(time_start, _time_end, _consultation_time, _between_time)
       when is_nil(time_start),
       do: []

  defp generate_time_slots(time_start, time_end, consultation_time, between_time) do
    slot_seconds = (consultation_time + between_time) * 60

    Stream.iterate(time_start, &Time.add(&1, slot_seconds, :second))
    |> Enum.take_while(&(Time.compare(&1, time_end) == :lt))
  end

  def update_schedule(%ScheduleSchema{} = schedule, attrs) do
    schedule
    |> ScheduleSchema.changeset(attrs)
    |> Repo.update()
  end

  def delete_schedule(%ScheduleSchema{} = schedule) do
    Repo.delete(schedule)
  end

  def change_schedule(%ScheduleSchema{} = schedule, attrs \\ %{}) do
    ScheduleSchema.changeset(schedule, attrs)
  end

  def update_detail_status(id, status, attrs \\ %{}) do
    detail = Repo.get!(ScheduleDetailSchema, id)

    detail
    |> ScheduleDetailSchema.changeset(Map.merge(%{status: status}, attrs))
    |> Repo.update()
  end
end
