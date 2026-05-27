defmodule Simpletask.Repo.Migrations.AddUnitIdToSchedulesAndScheduleDetails do
  use Ecto.Migration

  @unit_id "3420ee0d-44f6-4197-926f-c908d91e5964"

  def up do
    alter table(:schedules) do
      add :unit_id, references(:units, type: :binary_id, on_delete: :restrict), null: true
    end

    alter table(:schedule_details) do
      add :unit_id, references(:units, type: :binary_id, on_delete: :restrict), null: true
    end

    execute "UPDATE schedules SET unit_id = '#{@unit_id}' WHERE unit_id IS NULL"
    execute "UPDATE schedule_details SET unit_id = '#{@unit_id}' WHERE unit_id IS NULL"

    execute "ALTER TABLE schedules ALTER COLUMN unit_id SET NOT NULL"
    execute "ALTER TABLE schedule_details ALTER COLUMN unit_id SET NOT NULL"

    create index(:schedules, [:unit_id])
    create index(:schedule_details, [:unit_id])
  end

  def down do
    drop index(:schedules, [:unit_id])
    drop index(:schedule_details, [:unit_id])

    alter table(:schedules) do
      remove :unit_id
    end

    alter table(:schedule_details) do
      remove :unit_id
    end
  end
end
