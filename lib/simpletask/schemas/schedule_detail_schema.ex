defmodule Simpletask.Schemas.ScheduleDetailSchema do
  use Simpletask.Schema

  import Ecto.Changeset

  @fields_required [:schedule_time, :schedule_id, :status]
  @fields_optional [:patient_id]

  schema "schedule_details" do
    field :schedule_time, :time
    field :status, :string

    belongs_to :schedule, Simpletask.Schemas.ScheduleSchema
    belongs_to :patient, Simpletask.Schemas.PatientSchema

    timestamps(type: :utc_datetime)
  end

  @valid_statuses ~w(available cancelled marked)

  @doc false
  def changeset(detail, attrs) do
    detail
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
    |> validate_inclusion(:status, @valid_statuses)
  end
end
