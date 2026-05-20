defmodule Simpletask.Repo.Migrations.AddHealthInsuranceIdToSchedules do
  use Ecto.Migration

  def change do
    alter table(:schedules) do
      add :health_insurance_id, references(:health_insurances, type: :uuid, on_delete: :restrict), null: true
    end
  end
end
