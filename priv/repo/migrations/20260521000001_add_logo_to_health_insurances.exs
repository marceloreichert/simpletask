defmodule Simpletask.Repo.Migrations.AddLogoToHealthInsurances do
  use Ecto.Migration

  def change do
    alter table(:health_insurances) do
      add :logo, :text, null: true
    end
  end
end
