defmodule Simpletask.Repo.Migrations.CreateSpecialties do
  use Ecto.Migration

  def change do
    create table(:specialties, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :description, :text
      add :cbo_number, :string

      timestamps(type: :utc_datetime)
    end
  end
end
