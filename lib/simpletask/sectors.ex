defmodule Simpletask.Sectors do
  @moduledoc """
  The Sectors context.
  """

  import Ecto.Query, warn: false
  alias Simpletask.Repo

  alias Simpletask.Sectors.Sector

  @doc """
  Returns the list of sectors.

  ## Examples

      iex> list_sectors()
      [%Sector{}, ...]

  """
  def list_sectors(%{unit_id: unit_id} = _user) do
    Sector
    |> where([t], t.unit_id == ^unit_id)
    |> Repo.all()
  end

  @doc """
  Gets a single sector.

  Raises `Ecto.NoResultsError` if the Sector does not exist.

  ## Examples

      iex> get_sector!(123)
      %Sector{}

      iex> get_sector!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sector!(id), do: Repo.get!(Sector, id)

  @doc """
  Creates a sector.

  ## Examples

      iex> create_sector(%{field: value})
      {:ok, %Sector{}}

      iex> create_sector(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sector(attrs \\ %{}) do
    %Sector{}
    |> Sector.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sector.

  ## Examples

      iex> update_sector(sector, %{field: new_value})
      {:ok, %Sector{}}

      iex> update_sector(sector, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sector(%Sector{} = sector, attrs) do
    sector
    |> Sector.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sector.

  ## Examples

      iex> delete_sector(sector)
      {:ok, %Sector{}}

      iex> delete_sector(sector)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sector(%Sector{} = sector) do
    Repo.delete(sector)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sector changes.

  ## Examples

      iex> change_sector(sector)
      %Ecto.Changeset{data: %Sector{}}

  """
  def change_sector(%Sector{} = sector, attrs \\ %{}) do
    Sector.changeset(sector, attrs)
  end
end
