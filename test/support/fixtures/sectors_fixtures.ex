defmodule Simpletask.SectorsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Simpletask.Sectors` context.
  """

  @doc """
  Generate a sector.
  """
  def sector_fixture(attrs \\ %{}) do
    {:ok, sector} =
      attrs
      |> Enum.into(%{
        name: "some name",
        unit_id: "some unit_id"
      })
      |> Simpletask.Sectors.create_sector()

    sector
  end
end
