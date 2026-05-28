defmodule Simpletask.Policies.PatientPolicy do
  @behaviour Bodyguard.Policy

  def authorize(:list_patients, %{roles: roles}, _) when is_list(roles) do
    if Enum.any?(roles, &(&1 in [:master, :admin, :attend])), do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:show_patient, %{roles: roles}, _) when is_list(roles) do
    if Enum.any?(roles, &(&1 in [:master, :admin, :attend])), do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:new_patient, %{roles: roles}, _) when is_list(roles) do
    if Enum.any?(roles, &(&1 in [:master, :admin, :attend])), do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:edit_patient, %{roles: roles}, _) when is_list(roles) do
    if Enum.any?(roles, &(&1 in [:master, :admin, :attend])), do: :ok, else: {:error, :unauthorized}
  end

  def authorize(_, _user, _), do: {:error, :unauthorized}
end
