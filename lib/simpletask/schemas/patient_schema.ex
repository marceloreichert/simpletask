defmodule Simpletask.Schemas.PatientSchema do
  use Simpletask.Schema
  import Ecto.Changeset

  @fields_required [
    :name,
    :social_name,
    :unit_id
  ]

  @fields_optional [
    :mothers_name,
    :birthday,
    :nacionality,
    :local_of_birth,
    :date_of_naturalization,
    :country_of_naturalization,
    :document_passport_number,
    :document_passport_issue_date,
    :document_passport_issue_country,
    :document_passport_expiration_date,
    :email,
    :phone_type,
    :phone_ddd,
    :phone_number,
    :address_type,
    :address_description,
    :address_number,
    :address_complement,
    :address_district,
    :address_city,
    :address_uf,
    :address_country,
    :address_zip,
    :document_cpf,
    :document_id_number,
    :document_id_uf,
    :document_id_issuer,
    :document_id_issue_date,
    :document_cns,
    :legal_person
  ]

  @derive {Jason.Encoder, only: [:id] ++ @fields_required ++ @fields_optional}

  schema "patients" do
    field :name, :string
    field :social_name, :string
    field :mothers_name, :string
    field :birthday, :date
    field :nacionality, :string
    field :local_of_birth, :string
    field :date_of_naturalization, :date
    field :country_of_naturalization, :string
    field :document_passport_number, :string
    field :document_passport_issue_date, :date
    field :document_passport_issue_country, :string
    field :document_passport_expiration_date, :date
    field :email, :string
    field :phone_type, :string
    field :phone_ddd, :string
    field :phone_number, :string
    field :address_type, :string
    field :address_description, :string
    field :address_number, :string
    field :address_complement, :string
    field :address_district, :string
    field :address_city, :string
    field :address_uf, :string
    field :address_country, :string
    field :address_zip, :string
    field :document_cpf, :string
    field :document_id_number, :string
    field :document_id_uf, :string
    field :document_id_issuer, :string
    field :document_id_issue_date, :date
    field :document_cns, :string
    field :legal_person, :string

    belongs_to :unit, Simpletask.Schemas.UnitSchema

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(patient, attrs) do
    patient
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
  end
end
