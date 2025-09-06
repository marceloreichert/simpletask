defmodule Simpletask.Schemas.SpecialtySchema do
  use Simpletask.Schema

  import Ecto.Changeset

  @fields_required [
    :name,
    :description,
    :cbo_number
  ]

  @fields_optional []

  schema "specialties" do
    field :name, :string
    field :description, :string
    field :cbo_number, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(specialty, attrs) do
    specialty
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
  end
end
