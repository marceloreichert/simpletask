defmodule Simpletask.Repo.Migrations.AddScheduleTypeToSchedules do
  use Ecto.Migration

  def change do
    alter table(:schedules) do
      add :schedule_type, :string, null: true
    end
  end
end
