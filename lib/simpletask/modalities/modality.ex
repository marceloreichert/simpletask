defmodule Simpletask.Modalities.Modality do
  use Simpletask.Schema
  import Ecto.Changeset

  @fields_required [
    :name
  ]

  @fields_optional []

  @derive {Jason.Encoder, only: [:id, :name]}

  schema "modalities" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(modality, attrs) do
    modality
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
  end
end
