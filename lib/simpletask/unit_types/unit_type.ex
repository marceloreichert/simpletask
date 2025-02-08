defmodule Simpletask.UnitTypes.UnitType do
  use Simpletask.Schema
  import Ecto.Changeset

  @fields_required [
    :name
  ]

  @fields_optional []

  @derive {Jason.Encoder, only: [:id] ++ @fields_required ++ @fields_optional}

  schema "unit_types" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(unit_type, attrs) do
    unit_type
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
  end
end
