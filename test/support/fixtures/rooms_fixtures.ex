defmodule Simpletask.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Simpletask.Rooms` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        name: "some name",
        unit_id: "some unit_id"
      })
      |> Simpletask.Rooms.create_room()

    room
  end
end
