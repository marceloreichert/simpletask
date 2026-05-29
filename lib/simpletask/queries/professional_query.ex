defmodule Simpletask.Queries.ProfessionalQuery do
  @moduledoc """
  The Professionals context.
  """

  import Ecto.Query, warn: false

  alias Simpletask.Repo

  alias Simpletask.Schemas.ProfessionalSchema

  def list_professionals(%{unit_id: unit_id} = _user) do
    ProfessionalSchema
    |> where([t], t.unit_id == ^unit_id)
    |> Repo.all()
    |> Repo.preload([:specialty, :professional_type])
  end

  def get_professional!(id, user) do
    ProfessionalSchema
    |> where([p], p.id == ^id and p.unit_id == ^user.unit_id)
    |> Repo.one!()
    |> Repo.preload([:specialty, :professional_type])
  end

  def create_professional(attrs \\ %{}) do
    %ProfessionalSchema{}
    |> ProfessionalSchema.changeset(attrs)
    |> Repo.insert()
  end

  def update_professional(%ProfessionalSchema{} = professional, attrs) do
    professional
    |> ProfessionalSchema.changeset(attrs)
    |> Repo.update()
  end

  def delete_professional(%ProfessionalSchema{} = professional) do
    Repo.delete(professional)
  end

  def change_professional(%ProfessionalSchema{} = professional, attrs \\ %{}) do
    ProfessionalSchema.changeset(professional, attrs)
  end
end
