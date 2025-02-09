defmodule Simpletask.SpecialtiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Simpletask.Specialties` context.
  """

  @doc """
  Generate a specialty.
  """
  def specialty_fixture(attrs \\ %{}) do
    {:ok, specialty} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Simpletask.Specialties.create_specialty()

    specialty
  end
end
