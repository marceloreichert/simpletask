defmodule Simpletask.Policies.ModalityPolicy do
  @behaviour Bodyguard.Policy

  def authorize(:list_modalities, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:show_modality, %{roles: roles}, _) when is_list(roles) do
    if Enum.any?(roles, &(&1 in [:master, :admin])), do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:new_modality, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(:edit_modality, %{roles: roles}, _) when is_list(roles) do
    if :master in roles, do: :ok, else: {:error, :unauthorized}
  end

  def authorize(_, _user, _), do: {:error, :unauthorized}
end
