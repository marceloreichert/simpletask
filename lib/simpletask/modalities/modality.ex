defmodule Simpletask.Modalities.Modality do
  use Simpletask.Schema
  import Ecto.Changeset

  schema "modalities" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(modality, attrs) do
    modality
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
