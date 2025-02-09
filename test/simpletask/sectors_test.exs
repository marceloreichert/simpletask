defmodule Simpletask.SectorsTest do
  use Simpletask.DataCase

  alias Simpletask.Sectors

  describe "sectors" do
    alias Simpletask.Sectors.Sector

    import Simpletask.SectorsFixtures

    @invalid_attrs %{name: nil, unit_id: nil}

    test "list_sectors/0 returns all sectors" do
      sector = sector_fixture()
      assert Sectors.list_sectors() == [sector]
    end

    test "get_sector!/1 returns the sector with given id" do
      sector = sector_fixture()
      assert Sectors.get_sector!(sector.id) == sector
    end

    test "create_sector/1 with valid data creates a sector" do
      valid_attrs = %{name: "some name", unit_id: "some unit_id"}

      assert {:ok, %Sector{} = sector} = Sectors.create_sector(valid_attrs)
      assert sector.name == "some name"
      assert sector.unit_id == "some unit_id"
    end

    test "create_sector/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sectors.create_sector(@invalid_attrs)
    end

    test "update_sector/2 with valid data updates the sector" do
      sector = sector_fixture()
      update_attrs = %{name: "some updated name", unit_id: "some updated unit_id"}

      assert {:ok, %Sector{} = sector} = Sectors.update_sector(sector, update_attrs)
      assert sector.name == "some updated name"
      assert sector.unit_id == "some updated unit_id"
    end

    test "update_sector/2 with invalid data returns error changeset" do
      sector = sector_fixture()
      assert {:error, %Ecto.Changeset{}} = Sectors.update_sector(sector, @invalid_attrs)
      assert sector == Sectors.get_sector!(sector.id)
    end

    test "delete_sector/1 deletes the sector" do
      sector = sector_fixture()
      assert {:ok, %Sector{}} = Sectors.delete_sector(sector)
      assert_raise Ecto.NoResultsError, fn -> Sectors.get_sector!(sector.id) end
    end

    test "change_sector/1 returns a sector changeset" do
      sector = sector_fixture()
      assert %Ecto.Changeset{} = Sectors.change_sector(sector)
    end
  end
end
