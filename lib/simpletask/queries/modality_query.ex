defmodule Simpletask.Queries.ModalityQuery do
  @moduledoc """
  The Modalities context.
  """

  import Ecto.Query, warn: false

  alias Simpletask.Repo

  alias Simpletask.Schemas.ModalitySchema

  def list_modalities do
    Repo.all(ModalitySchema)
  end

  def get_modality!(id), do: Repo.get!(ModalitySchema, id)

  def create_modality(attrs \\ %{}) do
    %ModalitySchema{}
    |> ModalitySchema.changeset(attrs)
    |> Repo.insert()
  end

  def update_modality(%ModalitySchema{} = modality, attrs) do
    modality
    |> ModalitySchema.changeset(attrs)
    |> Repo.update()
  end

  def change_modality(%ModalitySchema{} = modality, attrs \\ %{}) do
    ModalitySchema.changeset(modality, attrs)
  end
end
