defmodule Simpletask.Repo.Migrations.AddSchedulingAllowedToSpecialties do
  use Ecto.Migration

  def change do
    alter table(:specialties) do
      add :scheduling_allowed, :boolean, default: false, null: false
    end
  end
end
