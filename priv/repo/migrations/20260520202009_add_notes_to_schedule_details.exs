defmodule Simpletask.Repo.Migrations.AddNotesToScheduleDetails do
  use Ecto.Migration

  def change do
    alter table(:schedule_details) do
      add :notes, :text, null: true
    end
  end
end
