defmodule Simpletask.Schemas.ProfessionalSchema do
  use Simpletask.Schema

  import Ecto.Changeset

  @fields_required [
    :name,
    :unit_id,
    :specialty_id
  ]

  @fields_optional [
    :social_name,
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
    :document_professional_type,
    :document_professional_number,
    :document_professional_uf
  ]

  schema "professionals" do
    field :social_name, :string
    field :nacionality, :string

    field :document_cns, :string

    field :document_professional_type, :string
    field :document_professional_number, :string
    field :document_professional_uf, :string

    field :document_cpf, :string

    field :document_passport_number, :string
    field :document_passport_issue_date, :date
    field :document_passport_issue_country, :string
    field :document_passport_expiration_date, :date

    field :document_id_number, :string
    field :document_id_issuer, :string
    field :document_id_issue_date, :date
    field :document_id_uf, :string

    field :phone_number, :string
    field :mothers_name, :string
    field :name, :string
    field :address_type, :string
    field :address_uf, :string
    field :birthday, :date
    field :address_city, :string
    field :address_district, :string
    field :address_country, :string
    field :address_number, :string
    field :phone_type, :string
    field :country_of_naturalization, :string
    field :email, :string
    field :date_of_naturalization, :date
    field :address_description, :string
    field :local_of_birth, :string
    field :address_complement, :string
    field :address_zip, :string
    field :phone_ddd, :string

    belongs_to :specialty, Simpletask.Schemas.SpecialtySchema
    belongs_to :unit, Simpletask.Schemas.UnitSchema

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(professional, attrs) do
    professional
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
  end
end
