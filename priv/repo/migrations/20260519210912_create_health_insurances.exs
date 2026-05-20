defmodule Simpletask.Repo.Migrations.CreateHealthInsurances do
  use Ecto.Migration

  def change do
    create table(:health_insurances, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
