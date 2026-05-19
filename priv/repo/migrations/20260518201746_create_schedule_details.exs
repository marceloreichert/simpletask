defmodule Simpletask.Repo.Migrations.CreateScheduleDetails do
  use Ecto.Migration

  def change do
    create table(:schedule_details, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :schedule_time, :time, null: false
      add :status, :string, null: false

      add :schedule_id, references(:schedules, type: :binary_id, on_delete: :delete_all),
        null: false

      add :patient_id, references(:patients, type: :binary_id, on_delete: :restrict)

      timestamps(type: :utc_datetime)
    end

    create index(:schedule_details, [:schedule_id])
    create index(:schedule_details, [:patient_id])
  end
end
