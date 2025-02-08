defmodule Simpletask.Repo.Migrations.CreateUnits do
  use Ecto.Migration

  def change do
    create table(:units, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :document_cnes, :string
      add :document_cnpj, :string
      add :address, :string
      add :address_number, :integer
      add :address_complement, :string
      add :address_city, :string
      add :address_uf, :string
      add :phone, :string
      add :email, :string

      add :unit_type_id, references(:unit_types, on_delete: :delete_all, type: :binary_id),
        null: false

      timestamps(type: :utc_datetime)
    end
  end
end
