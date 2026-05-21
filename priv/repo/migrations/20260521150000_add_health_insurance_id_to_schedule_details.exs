defmodule Simpletask.Repo.Migrations.AddHealthInsuranceIdToScheduleDetails do
  use Ecto.Migration

  def change do
    alter table(:schedule_details) do
      add :health_insurance_id, references(:health_insurances, type: :binary_id, on_delete: :nilify_all)
    end
  end
end
