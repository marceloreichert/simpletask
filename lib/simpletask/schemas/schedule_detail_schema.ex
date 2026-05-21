defmodule Simpletask.Schemas.ScheduleDetailSchema do
  use Simpletask.Schema

  import Ecto.Changeset

  @fields_required [:schedule_time, :schedule_id, :status]
  @fields_optional [:patient_id, :notes, :health_insurance_id]

  schema "schedule_details" do
    field :schedule_time, :time
    field :status, :string
    field :notes, :string

    belongs_to :schedule, Simpletask.Schemas.ScheduleSchema
    belongs_to :patient, Simpletask.Schemas.PatientSchema
    belongs_to :health_insurance, Simpletask.Schemas.HealthInsuranceSchema

    timestamps(type: :utc_datetime)
  end

  @valid_statuses ~w(available cancelled marked in_attendance attended showed_up done)

  @doc false
  def changeset(detail, attrs) do
    detail
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
    |> validate_inclusion(:status, @valid_statuses)
  end
end
