defmodule Simpletask.Schemas.ProfessionalSectorSchema do
  use Simpletask.Schema

  import Ecto.Changeset

  @fields_required [
    :name,
    :modality_id,
    :professional_id,
    :sector_id
  ]

  @fields_optional []

  schema "professional_sectors" do
    belongs_to :modality, Simpletask.Modalities.Modality
    belongs_to :professional, Simpletask.Professionals.Professional
    belongs_to :sector, Simpletask.Sectors.Sector

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
  end
end
