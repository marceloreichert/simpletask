defmodule Simpletask.Schemas.ProfessionalTypeSchema do
  use Simpletask.Schema

  import Ecto.Changeset

  @fields_required [:name]
  @fields_optional [:description]

  schema "professional_types" do
    field :name, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(professional_type, attrs) do
    professional_type
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
  end
end
