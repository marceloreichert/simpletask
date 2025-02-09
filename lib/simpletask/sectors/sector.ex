defmodule Simpletask.Sectors.Sector do
  use Ecto.Schema
  import Ecto.Changeset

  @fields_required [
    :name, :unit_id
  ]

  @fields_optional []

  schema "sectors" do
    field :name, :string

    belongs_to :unit, Simpletask.Units.Unit

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(sector, attrs) do
    sector
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
  end
end
