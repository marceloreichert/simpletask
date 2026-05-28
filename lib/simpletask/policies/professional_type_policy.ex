defmodule Simpletask.Policies.ProfessionalTypePolicy do
  @behaviour Bodyguard.Policy

  def authorize(:list_professional_types, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:show_professional_type, %{roles: roles}, _) when is_list(roles) do
    if Enum.any?(roles, &(&1 in [:master, :admin])), do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:new_professional_type, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:edit_professional_type, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:delete_professional_type, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(_, _user, _), do: {:error, :unauthorized}
end
