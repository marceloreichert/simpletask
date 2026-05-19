defmodule Simpletask.Queries.ScheduleQuery do
  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Simpletask.Repo
  alias Simpletask.Schemas.ScheduleSchema
  alias Simpletask.Schemas.ScheduleDetailSchema

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
      order_by: s.schedule_time_start,
      preload: [professional: :specialty]
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

  def list_professional_options(%{unit_id: unit_id} = _user) do
    Simpletask.Schemas.ProfessionalSchema
    |> where([p], p.unit_id == ^unit_id)
    |> Repo.all()
    |> Enum.map(fn p -> {p.name, p.id} end)
  end

  def get_schedule!(id),
    do:
      Repo.get!(ScheduleSchema, id)
      |> Repo.preload([
        :room,
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
