defmodule Simpletask.Queries.PatientQuery do
  @moduledoc """
  The Patients context.
  """

  import Ecto.Query, warn: false
  alias Simpletask.Repo

  alias Simpletask.Schemas.PatientSchema

  @doc """
  Returns the list of patient.

  ## Examples

      iex> list_patient()
      [%Patient{}, ...]

  """
  def list_patient(user) do
    PatientSchema
    |> where([p], p.unit_id == ^user.unit_id)
    |> Repo.all()
  end

  @doc """
  Gets a single patient.

  Raises `Ecto.NoResultsError` if the Patient does not exist.

  ## Examples

      iex> get_patient!(123)
      %Patient{}

      iex> get_patient!(456)
      ** (Ecto.NoResultsError)

  """
  def get_patient!(id), do: Repo.get!(PatientSchema, id)

  @doc """
  Creates a patient.

  ## Examples

      iex> create_patient(%{field: value})
      {:ok, %Patient{}}

      iex> create_patient(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_patient(attrs \\ %{}) do
    %PatientSchema{}
    |> PatientSchema.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a patient.

  ## Examples

      iex> update_patient(patient, %{field: new_value})
      {:ok, %Patient{}}

      iex> update_patient(patient, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_patient(%PatientSchema{} = patient, attrs) do
    patient
    |> PatientSchema.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking patient changes.

  ## Examples

      iex> change_patient(patient)
      %Ecto.Changeset{data: %Patient{}}

  """
  def change_patient(%PatientSchema{} = patient, attrs \\ %{}) do
    PatientSchema.changeset(patient, attrs)
  end
end
