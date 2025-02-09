defmodule Simpletask.Repo.Migrations.CreateProfessional do
  use Ecto.Migration

  def change do
    create table(:professionals, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :social_name, :string
      add :mothers_name, :string
      add :birthday, :date
      add :nacionality, :string
      add :local_of_birth, :string
      add :date_of_naturalization, :date
      add :country_of_naturalization, :string
      add :email, :string
      add :phone_type, :string
      add :phone_ddd, :string
      add :phone_number, :string
      add :address_type, :string
      add :address_description, :string
      add :address_number, :string
      add :address_complement, :string
      add :address_district, :string
      add :address_city, :string
      add :address_uf, :string
      add :address_country, :string
      add :address_zip, :string
      add :document_cpf, :string
      add :document_id_number, :string
      add :document_id_uf, :string
      add :document_id_issuer, :string
      add :document_id_issue_date, :date
      add :document_passport_number, :string
      add :document_passport_issue_date, :date
      add :document_passport_issue_country, :string
      add :document_passport_expiration_date, :date
      add :document_cns, :string
      add :document_professional_type, :string
      add :document_professional_number, :string
      add :document_professional_uf, :string

      add :specialty_id, references(:specialties, on_delete: :delete_all, type: :binary_id),
        null: false

        add :unit_id, references(:units, on_delete: :delete_all, type: :binary_id), null: false
        add :sector_id, references(:sectors, on_delete: :delete_all, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:professionals, [:document_cpf])
  end
end
