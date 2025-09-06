defmodule Simpletask.Repo.Migrations.CreatePatient do
  use Ecto.Migration

  def change do
    create table(:patients, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :social_name, :string
      add :mothers_name, :string
      add :birthday, :date
      add :nacionality, :string
      add :local_of_birth, :string
      add :date_of_naturalization, :date
      add :country_of_naturalization, :string
      add :document_passport_number, :string
      add :document_passport_issue_date, :date
      add :document_passport_issue_country, :string
      add :document_passport_expiration_date, :date
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
      add :document_cns, :string
      add :legal_person, :string

      add :unit_id, references(:units, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
