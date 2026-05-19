defmodule Simpletask.Repo.Migrations.CreateSchedules do
  use Ecto.Migration

  @disable_ddl_transaction true

  def change do
    create table(:schedules, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :schedule_date, :date, null: false
      add :schedule_time_start, :time, null: false
      add :schedule_time_end, :time, null: false
      add :schedule_consultation_time, :integer
      add :schedule_time_between_consultation, :integer

      add :professional_id, references(:professionals, type: :binary_id, on_delete: :delete_all),
        null: false

      add :room_id, references(:rooms, type: :binary_id, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:schedules, [:professional_id])
    create index(:schedules, [:schedule_date])
  end
end
