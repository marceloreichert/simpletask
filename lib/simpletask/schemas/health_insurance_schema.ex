defmodule Simpletask.Schemas.HealthInsuranceSchema do
  use Simpletask.Schema

  import Ecto.Changeset

  @fields_required [:name]
  @fields_optional []

  schema "health_insurances" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(health_insurance, attrs) do
    health_insurance
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
  end
end
