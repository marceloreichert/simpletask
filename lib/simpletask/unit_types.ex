defmodule Simpletask.UnitTypes do
  @moduledoc """
  The UnitTypes context.
  """

  import Ecto.Query, warn: false
  alias Simpletask.Repo

  alias Simpletask.UnitTypes.UnitType

  @doc """
  Returns the list of unit_types.

  ## Examples

      iex> list_unit_types()
      [%UnitType{}, ...]

  """
  def list_unit_types do
    Repo.all(UnitType)
  end

  @doc """
  Gets a single unit_type.

  Raises `Ecto.NoResultsError` if the Unit type does not exist.

  ## Examples

      iex> get_unit_type!(123)
      %UnitType{}

      iex> get_unit_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_unit_type!(id), do: Repo.get!(UnitType, id)

  @doc """
  Creates a unit_type.

  ## Examples

      iex> create_unit_type(%{field: value})
      {:ok, %UnitType{}}

      iex> create_unit_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_unit_type(attrs \\ %{}) do
    %UnitType{}
    |> UnitType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a unit_type.

  ## Examples

      iex> update_unit_type(unit_type, %{field: new_value})
      {:ok, %UnitType{}}

      iex> update_unit_type(unit_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_unit_type(%UnitType{} = unit_type, attrs) do
    unit_type
    |> UnitType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a unit_type.

  ## Examples

      iex> delete_unit_type(unit_type)
      {:ok, %UnitType{}}

      iex> delete_unit_type(unit_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_unit_type(%UnitType{} = unit_type) do
    Repo.delete(unit_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking unit_type changes.

  ## Examples

      iex> change_unit_type(unit_type)
      %Ecto.Changeset{data: %UnitType{}}

  """
  def change_unit_type(%UnitType{} = unit_type, attrs \\ %{}) do
    UnitType.changeset(unit_type, attrs)
  end
end
