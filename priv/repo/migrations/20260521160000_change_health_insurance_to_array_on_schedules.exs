defmodule Simpletask.Repo.Migrations.ChangeHealthInsuranceToArrayOnSchedules do
  use Ecto.Migration

  def change do
    alter table(:schedules) do
      add :health_insurance_ids, {:array, :uuid}, default: [], null: false
      remove :health_insurance_id
    end
  end
end
