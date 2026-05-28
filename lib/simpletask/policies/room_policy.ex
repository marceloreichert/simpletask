defmodule Simpletask.Policies.RoomPolicy do
  @behaviour Bodyguard.Policy

  def authorize(:list_rooms, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:show_room, %{roles: roles}, _) when is_list(roles) do
    if Enum.any?(roles, &(&1 in [:master, :admin])), do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:new_room, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:edit_room, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:delete_room, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(_, _user, _), do: {:error, :unauthorized}
end
