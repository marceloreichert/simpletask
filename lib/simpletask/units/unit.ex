defmodule Simpletask.Units.Unit do
  use Simpletask.Schema
  import Ecto.Changeset

  schema "units" do
    field :name, :string
    field :address, :string
    field :document_cnes, :string
    field :document_cnpj, :string
    field :unit_type, :integer
    field :address_number, :integer
    field :address_complement, :string
    field :address_city, :string
    field :address_uf, :string
    field :phone, :string
    field :email, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(unit, attrs) do
    unit
    |> cast(attrs, [:name, :document_cnes, :document_cnpj, :unit_type, :address, :address_number, :address_complement, :address_city, :address_uf, :phone, :email])
    |> validate_required([:name, :document_cnes, :document_cnpj, :unit_type, :address, :address_number, :address_complement, :address_city, :address_uf, :phone, :email])
  end
end
