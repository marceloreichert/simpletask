defmodule Simpletask.Repo.Migrations.CreateProfessionalSector do
  use Ecto.Migration

  def change do
    create table(:professional_sectors, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :professional_id, references(:professionals, type: :binary_id), null: false
      add :sector_id, references(:sectors, type: :binary_id), null: false
      add :modality_id, references(:modalities, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
