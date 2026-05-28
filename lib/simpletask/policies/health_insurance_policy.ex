defmodule Simpletask.Policies.HealthInsurancePolicy do
  @behaviour Bodyguard.Policy

  def authorize(:list_health_insurances, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:new_health_insurance, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:edit_health_insurance, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:delete_health_insurance, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(_, _user, _), do: {:error, :unauthorized}
end
