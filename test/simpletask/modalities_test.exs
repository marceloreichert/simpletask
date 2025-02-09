defmodule Simpletask.ModalitiesTest do
  use Simpletask.DataCase

  alias Simpletask.Modalities

  describe "modalities" do
    alias Simpletask.Modalities.Modality

    import Simpletask.ModalitiesFixtures

    @invalid_attrs %{name: nil, unit_id: nil}

    test "list_modalities/0 returns all modalities" do
      modality = modality_fixture()
      assert Modalities.list_modalities() == [modality]
    end

    test "get_modality!/1 returns the modality with given id" do
      modality = modality_fixture()
      assert Modalities.get_modality!(modality.id) == modality
    end

    test "create_modality/1 with valid data creates a modality" do
      valid_attrs = %{name: "some name", unit_id: "some unit_id"}

      assert {:ok, %Modality{} = modality} = Modalities.create_modality(valid_attrs)
      assert modality.name == "some name"
      assert modality.unit_id == "some unit_id"
    end

    test "create_modality/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Modalities.create_modality(@invalid_attrs)
    end

    test "update_modality/2 with valid data updates the modality" do
      modality = modality_fixture()
      update_attrs = %{name: "some updated name", unit_id: "some updated unit_id"}

      assert {:ok, %Modality{} = modality} = Modalities.update_modality(modality, update_attrs)
      assert modality.name == "some updated name"
      assert modality.unit_id == "some updated unit_id"
    end

    test "update_modality/2 with invalid data returns error changeset" do
      modality = modality_fixture()
      assert {:error, %Ecto.Changeset{}} = Modalities.update_modality(modality, @invalid_attrs)
      assert modality == Modalities.get_modality!(modality.id)
    end

    test "delete_modality/1 deletes the modality" do
      modality = modality_fixture()
      assert {:ok, %Modality{}} = Modalities.delete_modality(modality)
      assert_raise Ecto.NoResultsError, fn -> Modalities.get_modality!(modality.id) end
    end

    test "change_modality/1 returns a modality changeset" do
      modality = modality_fixture()
      assert %Ecto.Changeset{} = Modalities.change_modality(modality)
    end
  end
end
