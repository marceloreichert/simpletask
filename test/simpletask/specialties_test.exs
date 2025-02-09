defmodule Simpletask.SpecialtiesTest do
  use Simpletask.DataCase

  alias Simpletask.Specialties

  describe "specialties" do
    alias Simpletask.Specialties.Specialty

    import Simpletask.SpecialtiesFixtures

    @invalid_attrs %{name: nil}

    test "list_specialties/0 returns all specialties" do
      specialty = specialty_fixture()
      assert Specialties.list_specialties() == [specialty]
    end

    test "get_specialty!/1 returns the specialty with given id" do
      specialty = specialty_fixture()
      assert Specialties.get_specialty!(specialty.id) == specialty
    end

    test "create_specialty/1 with valid data creates a specialty" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Specialty{} = specialty} = Specialties.create_specialty(valid_attrs)
      assert specialty.name == "some name"
    end

    test "create_specialty/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Specialties.create_specialty(@invalid_attrs)
    end

    test "update_specialty/2 with valid data updates the specialty" do
      specialty = specialty_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Specialty{} = specialty} =
               Specialties.update_specialty(specialty, update_attrs)

      assert specialty.name == "some updated name"
    end

    test "update_specialty/2 with invalid data returns error changeset" do
      specialty = specialty_fixture()
      assert {:error, %Ecto.Changeset{}} = Specialties.update_specialty(specialty, @invalid_attrs)
      assert specialty == Specialties.get_specialty!(specialty.id)
    end

    test "delete_specialty/1 deletes the specialty" do
      specialty = specialty_fixture()
      assert {:ok, %Specialty{}} = Specialties.delete_specialty(specialty)
      assert_raise Ecto.NoResultsError, fn -> Specialties.get_specialty!(specialty.id) end
    end

    test "change_specialty/1 returns a specialty changeset" do
      specialty = specialty_fixture()
      assert %Ecto.Changeset{} = Specialties.change_specialty(specialty)
    end
  end
end
