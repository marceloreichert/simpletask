defmodule Simpletask.Modalities.Modality do
  use Ecto.Schema
  import Ecto.Changeset

  schema "modalities" do
    field :name, :string
    field :unit_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(modality, attrs) do
    modality
    |> cast(attrs, [:name, :unit_id])
    |> validate_required([:name, :unit_id])
  end
end
