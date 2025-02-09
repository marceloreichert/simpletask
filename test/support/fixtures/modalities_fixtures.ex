defmodule Simpletask.ModalitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Simpletask.Modalities` context.
  """

  @doc """
  Generate a modality.
  """
  def modality_fixture(attrs \\ %{}) do
    {:ok, modality} =
      attrs
      |> Enum.into(%{
        name: "some name",
        unit_id: "some unit_id"
      })
      |> Simpletask.Modalities.create_modality()

    modality
  end
end
