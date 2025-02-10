defmodule Simpletask.Repo.Migrations.CreateSectors do
  use Ecto.Migration

  def change do
    create table(:sectors, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string

      add :unit_id, references(:units, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
