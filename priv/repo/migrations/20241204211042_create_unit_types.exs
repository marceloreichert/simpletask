defmodule Simpletask.Repo.Migrations.CreateUnitTypes do
  use Ecto.Migration

  def change do
    create table(:unit_types, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
