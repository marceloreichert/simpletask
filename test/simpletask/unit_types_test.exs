defmodule Simpletask.UnitTypesTest do
  use Simpletask.DataCase

  alias Simpletask.UnitTypes

  describe "unit_types" do
    alias Simpletask.UnitTypes.UnitType

    import Simpletask.UnitTypesFixtures

    @invalid_attrs %{name: nil}

    test "list_unit_types/0 returns all unit_types" do
      unit_type = unit_type_fixture()
      assert UnitTypes.list_unit_types() == [unit_type]
    end

    test "get_unit_type!/1 returns the unit_type with given id" do
      unit_type = unit_type_fixture()
      assert UnitTypes.get_unit_type!(unit_type.id) == unit_type
    end

    test "create_unit_type/1 with valid data creates a unit_type" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %UnitType{} = unit_type} = UnitTypes.create_unit_type(valid_attrs)
      assert unit_type.name == "some name"
    end

    test "create_unit_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UnitTypes.create_unit_type(@invalid_attrs)
    end

    test "update_unit_type/2 with valid data updates the unit_type" do
      unit_type = unit_type_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %UnitType{} = unit_type} = UnitTypes.update_unit_type(unit_type, update_attrs)
      assert unit_type.name == "some updated name"
    end

    test "update_unit_type/2 with invalid data returns error changeset" do
      unit_type = unit_type_fixture()
      assert {:error, %Ecto.Changeset{}} = UnitTypes.update_unit_type(unit_type, @invalid_attrs)
      assert unit_type == UnitTypes.get_unit_type!(unit_type.id)
    end

    test "delete_unit_type/1 deletes the unit_type" do
      unit_type = unit_type_fixture()
      assert {:ok, %UnitType{}} = UnitTypes.delete_unit_type(unit_type)
      assert_raise Ecto.NoResultsError, fn -> UnitTypes.get_unit_type!(unit_type.id) end
    end

    test "change_unit_type/1 returns a unit_type changeset" do
      unit_type = unit_type_fixture()
      assert %Ecto.Changeset{} = UnitTypes.change_unit_type(unit_type)
    end
  end
end
