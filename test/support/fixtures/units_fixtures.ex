defmodule Simpletask.UnitsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Simpletask.Units` context.
  """

  @doc """
  Generate a unit.
  """
  def unit_fixture(attrs \\ %{}) do
    {:ok, unit} =
      attrs
      |> Enum.into(%{
        address: "some address",
        address_city: "some address_city",
        address_complement: "some address_complement",
        address_number: 42,
        address_uf: "some address_uf",
        document_cnes: "some document_cnes",
        document_cnpj: "some document_cnpj",
        email: "some email",
        name: "some name",
        phone: "some phone",
        unit_type: 42
      })
      |> Simpletask.Units.create_unit()

    unit
  end
end
