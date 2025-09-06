defmodule Simpletask.Queries.ProfessionalQuery do
  @moduledoc """
  The Professionals context.
  """

  import Ecto.Query, warn: false

  alias Simpletask.Repo

  alias Simpletask.Schemas.ProfessionalSchema

  @doc """
  Returns the list of professional.

  ## Examples

      iex> list_professional()
      [%Professional{}, ...]

  """
  def list_professional(%{unit_id: unit_id} = _user) do
    ProfessionalSchema
    |> where([t], t.unit_id == ^unit_id)
    |> Repo.all()
    |> Repo.preload(:specialty)
  end

  @doc """
  Gets a single professional.

  Raises `Ecto.NoResultsError` if the Professional does not exist.

  ## Examples

      iex> get_professional!(123)
      %Professional{}

      iex> get_professional!(456)
      ** (Ecto.NoResultsError)

  """
  def get_professional!(id), do: Repo.get!(ProfessionalSchema, id)

  @doc """
  Creates a professional.

  ## Examples

      iex> create_professional(%{field: value})
      {:ok, %Professional{}}

      iex> create_professional(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_professional(attrs \\ %{}) do
    %ProfessionalSchema{}
    |> Professional.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a professional.

  ## Examples

      iex> update_professional(professional, %{field: new_value})
      {:ok, %Professional{}}

      iex> update_professional(professional, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_professional(%ProfessionalSchema{} = professional, attrs) do
    professional
    |> ProfessionalSchema.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a professional.

  ## Examples

      iex> delete_professional(professional)
      {:ok, %Professional{}}

      iex> delete_professional(professional)
      {:error, %Ecto.Changeset{}}

  """
  def delete_professional(%ProfessionalSchema{} = professional) do
    Repo.delete(professional)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking professional changes.

  ## Examples

      iex> change_professional(professional)
      %Ecto.Changeset{data: %Professional{}}

  """
  def change_professional(%ProfessionalSchema{} = professional, attrs \\ %{}) do
    ProfessionalSchema.changeset(professional, attrs)
  end
end
