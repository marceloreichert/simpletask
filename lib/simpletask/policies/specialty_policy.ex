defmodule Simpletask.Policies.SpecialtyPolicy do
  @behaviour Bodyguard.Policy

  def authorize(:list_specialties, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:show_specialty, %{roles: roles}, _) when is_list(roles) do
    if Enum.any?(roles, &(&1 in [:master, :admin])), do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:new_specialty, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:edit_specialty, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:delete_specialty, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(_, _user, _), do: {:error, :unauthorized}
end
