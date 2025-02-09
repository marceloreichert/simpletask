defmodule Simpletask.Repo.Migrations.CreateModalities do
  use Ecto.Migration

  def change do
    create table(:modalities, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
