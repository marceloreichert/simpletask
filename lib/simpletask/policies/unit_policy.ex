defmodule Simpletask.Policies.UnitPolicy do
  @behaviour Bodyguard.Policy

  def authorize(:menu_unit, %{roles: roles}, _unit) when is_list(roles) do
    if Enum.any?(roles, &(&1 in [:master, :admin])), do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:show_unit, %{roles: roles}, _unit) when is_list(roles) do
    if Enum.any?(roles, &(&1 in [:master, :admin])), do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:list_units, %{roles: roles}, _unit) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:edit_unit, %{roles: roles}, _unit) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:new_unit, %{roles: roles}, _unit) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(_, _user, _unit), do: {:error, :unauthorized}
end
