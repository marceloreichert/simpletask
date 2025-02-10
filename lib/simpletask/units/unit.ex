defmodule Simpletask.Units.Unit do
  use Simpletask.Schema
  import Ecto.Changeset

  @fields_required [
    :name,
    :modality_id
  ]

  @fields_optional [
    :document_cnes,
    :document_cnpj,
    :address,
    :address_number,
    :address_complement,
    :address_city,
    :address_uf,
    :phone,
    :email
  ]

  @derive {Jason.Encoder, only: [:id] ++ @fields_required ++ @fields_optional}

  schema "units" do
    field :name, :string
    field :address, :string
    field :document_cnes, :string
    field :document_cnpj, :string
    field :address_number, :integer
    field :address_complement, :string
    field :address_city, :string
    field :address_uf, :string
    field :phone, :string
    field :email, :string

    belongs_to :modality, Simpletask.Modalities.Modality

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(unit, attrs) do
    unit
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
  end
end
