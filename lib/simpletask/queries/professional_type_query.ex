defmodule Simpletask.Queries.ProfessionalTypeQuery do
  import Ecto.Query, warn: false

  alias Simpletask.Repo
  alias Simpletask.Schemas.ProfessionalTypeSchema

  def list_professional_types do
    Repo.all(from pt in ProfessionalTypeSchema, order_by: [asc: pt.name])
  end

  def list_professional_type_options do
    Enum.map(list_professional_types(), fn pt -> {pt.name, pt.id} end)
  end

  def get_professional_type!(id), do: Repo.get!(ProfessionalTypeSchema, id)

  def create_professional_type(attrs \\ %{}) do
    %ProfessionalTypeSchema{}
    |> ProfessionalTypeSchema.changeset(attrs)
    |> Repo.insert()
  end

  def update_professional_type(%ProfessionalTypeSchema{} = professional_type, attrs) do
    professional_type
    |> ProfessionalTypeSchema.changeset(attrs)
    |> Repo.update()
  end

  def delete_professional_type(%ProfessionalTypeSchema{} = professional_type) do
    Repo.delete(professional_type)
  end

  def change_professional_type(%ProfessionalTypeSchema{} = professional_type, attrs \\ %{}) do
    ProfessionalTypeSchema.changeset(professional_type, attrs)
  end
end
