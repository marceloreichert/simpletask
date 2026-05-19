defmodule Simpletask.Queries.UnitQuery do
  @moduledoc """
  The Units context.
  """

  import Ecto.Query, warn: false

  alias Simpletask.Repo

  alias Simpletask.Schemas.UnitSchema

  def list_units(user) do
    unit = get_unit!(user.unit_id)
    [%UnitSchema{id: unit.id, name: unit.name}]
  end

  def list_units_options(user) do
    unit = get_unit!(user.unit_id)
    [{unit.name, unit.id}]
  end

  def get_unit!(id), do: Repo.get!(UnitSchema, id) |> Repo.preload(:modality)

  def create_unit(attrs \\ %{}) do
    %UnitSchema{}
    |> UnitSchema.changeset(attrs)
    |> Repo.insert()
  end

  def update_unit(%UnitSchema{} = unit, attrs) do
    unit
    |> UnitSchema.changeset(attrs)
    |> Repo.update()
  end

  def change_unit(%UnitSchema{} = unit, attrs \\ %{}) do
    UnitSchema.changeset(unit, attrs)
  end
end
