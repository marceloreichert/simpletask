defmodule Simpletask.UnitTypes.UnitType do
  use Simpletask.Schema
  import Ecto.Changeset

  schema "unit_types" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(unit_type, attrs) do
    unit_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
