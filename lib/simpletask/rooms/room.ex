defmodule Simpletask.Rooms.Room do
  use Simpletask.Schema
  import Ecto.Changeset

  @fields_required [
    :name,
    :unit_id,
    :user_id
  ]

  @fields_optional []

  schema "rooms" do
    field :name, :string

    belongs_to :unit, Simpletask.Units.Unit
    belongs_to :user, Simpletask.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, @fields_required ++ @fields_optional)
    |> validate_required(@fields_required)
  end
end
