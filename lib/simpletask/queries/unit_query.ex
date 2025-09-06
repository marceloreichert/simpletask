defmodule Simpletask.Queries.UnitQuery do
  @moduledoc """
  The Units context.
  """

  import Ecto.Query, warn: false

  alias Simpletask.Repo

  alias Simpletask.Schemas.UnitSchema

  @doc """
  Returns the list of units.

  ## Examples

      iex> list_units()
      [%Unit{}, ...]

  """
  def list_units(user) do
    [get_unit!(user.unit_id)]
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
