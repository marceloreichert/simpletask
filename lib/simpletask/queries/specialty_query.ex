defmodule Simpletask.Queries.SpecialtyQuery do
  @moduledoc """
  The Specialties context.
  """

  import Ecto.Query, warn: false
  alias Simpletask.Repo

  alias Simpletask.Schemas.SpecialtySchema

  @doc """
  Returns the list of specialties.

  ## Examples

      iex> list_specialties()
      [%Specialty{}, ...]

  """
  def list_specialties do
    Repo.all(SpecialtySchema)
  end

  @doc """
  Gets a single specialty.

  Raises `Ecto.NoResultsError` if the Specialty does not exist.

  ## Examples

      iex> get_specialty!(123)
      %Specialty{}

      iex> get_specialty!(456)
      ** (Ecto.NoResultsError)

  """
  def get_specialty!(id), do: Repo.get!(SpecialtySchema, id)

  @doc """
  Creates a specialty.

  ## Examples

      iex> create_specialty(%{field: value})
      {:ok, %Specialty{}}

      iex> create_specialty(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_specialty(attrs \\ %{}) do
    %SpecialtySchema{}
    |> SpecialtySchema.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a specialty.

  ## Examples

      iex> update_specialty(specialty, %{field: new_value})
      {:ok, %Specialty{}}

      iex> update_specialty(specialty, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_specialty(%SpecialtySchema{} = specialty, attrs) do
    specialty
    |> SpecialtySchema.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a specialty.

  ## Examples

      iex> delete_specialty(specialty)
      {:ok, %Specialty{}}

      iex> delete_specialty(specialty)
      {:error, %Ecto.Changeset{}}

  """
  def delete_specialty(%SpecialtySchema{} = specialty) do
    Repo.delete(specialty)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking specialty changes.

  ## Examples

      iex> change_specialty(specialty)
      %Ecto.Changeset{data: %Specialty{}}

  """
  def change_specialty(%SpecialtySchema{} = specialty, attrs \\ %{}) do
    SpecialtySchema.changeset(specialty, attrs)
  end
end
