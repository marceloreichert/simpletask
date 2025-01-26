defmodule Simpletask.UnitsTest do
  use Simpletask.DataCase

  alias Simpletask.Units

  describe "units" do
    alias Simpletask.Units.Unit

    import Simpletask.UnitsFixtures

    @invalid_attrs %{name: nil, address: nil, document_cnes: nil, document_cnpj: nil, unit_type: nil, address_number: nil, address_complement: nil, address_city: nil, address_uf: nil, phone: nil, email: nil}

    test "list_units/0 returns all units" do
      unit = unit_fixture()
      assert Units.list_units() == [unit]
    end

    test "get_unit!/1 returns the unit with given id" do
      unit = unit_fixture()
      assert Units.get_unit!(unit.id) == unit
    end

    test "create_unit/1 with valid data creates a unit" do
      valid_attrs = %{name: "some name", address: "some address", document_cnes: "some document_cnes", document_cnpj: "some document_cnpj", unit_type: 42, address_number: 42, address_complement: "some address_complement", address_city: "some address_city", address_uf: "some address_uf", phone: "some phone", email: "some email"}

      assert {:ok, %Unit{} = unit} = Units.create_unit(valid_attrs)
      assert unit.name == "some name"
      assert unit.address == "some address"
      assert unit.document_cnes == "some document_cnes"
      assert unit.document_cnpj == "some document_cnpj"
      assert unit.unit_type == 42
      assert unit.address_number == 42
      assert unit.address_complement == "some address_complement"
      assert unit.address_city == "some address_city"
      assert unit.address_uf == "some address_uf"
      assert unit.phone == "some phone"
      assert unit.email == "some email"
    end

    test "create_unit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Units.create_unit(@invalid_attrs)
    end

    test "update_unit/2 with valid data updates the unit" do
      unit = unit_fixture()
      update_attrs = %{name: "some updated name", address: "some updated address", document_cnes: "some updated document_cnes", document_cnpj: "some updated document_cnpj", unit_type: 43, address_number: 43, address_complement: "some updated address_complement", address_city: "some updated address_city", address_uf: "some updated address_uf", phone: "some updated phone", email: "some updated email"}

      assert {:ok, %Unit{} = unit} = Units.update_unit(unit, update_attrs)
      assert unit.name == "some updated name"
      assert unit.address == "some updated address"
      assert unit.document_cnes == "some updated document_cnes"
      assert unit.document_cnpj == "some updated document_cnpj"
      assert unit.unit_type == 43
      assert unit.address_number == 43
      assert unit.address_complement == "some updated address_complement"
      assert unit.address_city == "some updated address_city"
      assert unit.address_uf == "some updated address_uf"
      assert unit.phone == "some updated phone"
      assert unit.email == "some updated email"
    end

    test "update_unit/2 with invalid data returns error changeset" do
      unit = unit_fixture()
      assert {:error, %Ecto.Changeset{}} = Units.update_unit(unit, @invalid_attrs)
      assert unit == Units.get_unit!(unit.id)
    end

    test "delete_unit/1 deletes the unit" do
      unit = unit_fixture()
      assert {:ok, %Unit{}} = Units.delete_unit(unit)
      assert_raise Ecto.NoResultsError, fn -> Units.get_unit!(unit.id) end
    end

    test "change_unit/1 returns a unit changeset" do
      unit = unit_fixture()
      assert %Ecto.Changeset{} = Units.change_unit(unit)
    end
  end
end
