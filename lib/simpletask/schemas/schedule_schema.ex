defmodule Simpletask.Schemas.ScheduleSchema do
  use Simpletask.Schema

  import Ecto.Changeset

  @fields_required [
    :schedule_date,
    :schedule_time_start,
    :schedule_time_end,
    :schedule_consultation_time,
    :schedule_time_between_consultation,
    :professional_id,
    :room_id
  ]

  @fields_optional []

  schema "schedules" do
    field :schedule_date, :date
    field :schedule_time_start, :time
    field :schedule_time_end, :time
    field :schedule_consultation_time, :integer
    field :schedule_time_between_consultation, :integer

    belongs_to :professional, Simpletask.Schemas.ProfessionalSchema
    belongs_to :room, Simpletask.Schemas.RoomSchema

    has_many :schedule_details, Simpletask.Schemas.ScheduleDetailSchema, foreign_key: :schedule_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(schedule, attrs) do
    schedule
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
  end
end
