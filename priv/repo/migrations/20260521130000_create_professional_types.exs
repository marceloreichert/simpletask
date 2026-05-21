defmodule Simpletask.Repo.Migrations.CreateProfessionalTypes do
  use Ecto.Migration

  def change do
    create table(:professional_types, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
