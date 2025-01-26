defmodule Simpletask.UnitTypesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Simpletask.UnitTypes` context.
  """

  @doc """
  Generate a unit_type.
  """
  def unit_type_fixture(attrs \\ %{}) do
    {:ok, unit_type} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Simpletask.UnitTypes.create_unit_type()

    unit_type
  end
end
