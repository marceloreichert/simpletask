defmodule Simpletask.Repo.Migrations.AddUnitIdToSpecialties do
  use Ecto.Migration

  def change do
    alter table(:specialties) do
      add :unit_id, references(:units, type: :binary_id, on_delete: :nilify_all)
    end

    create index(:specialties, [:unit_id])
  end
end
