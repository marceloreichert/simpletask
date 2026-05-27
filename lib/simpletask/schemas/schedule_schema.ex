defmodule Simpletask.Schemas.ScheduleSchema do
  use Simpletask.Schema

  import Ecto.Changeset

  @fields_required [
    :schedule_date,
    :schedule_time_start,
    :schedule_time_end,
    :schedule_consultation_time,
    :schedule_time_between_consultation,
    :schedule_type,
    :professional_id,
    :room_id,
    :unit_id
  ]

  @fields_optional [:health_insurance_ids]

  @valid_types ~w(health_insurance unique)

  @type_labels %{"health_insurance" => "Convênio", "unique" => "Única"}

  def schedule_type_options do
    Enum.map(@valid_types, &{@type_labels[&1], &1})
  end

  schema "schedules" do
    field :schedule_date, :date
    field :schedule_time_start, :time
    field :schedule_time_end, :time
    field :schedule_consultation_time, :integer
    field :schedule_time_between_consultation, :integer
    field :schedule_type, :string
    field :health_insurance_ids, {:array, Ecto.UUID}, default: []

    belongs_to :unit, Simpletask.Schemas.UnitSchema
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
    |> validate_inclusion(:schedule_type, @valid_types)
    |> validate_health_insurance()
  end

  defp validate_health_insurance(changeset) do
    case get_field(changeset, :schedule_type) do
      "health_insurance" ->
        ids = get_field(changeset, :health_insurance_ids) || []
        if ids == [], do: add_error(changeset, :health_insurance_ids, "selecione pelo menos um convênio"), else: changeset
      _ -> changeset
    end
  end
end
