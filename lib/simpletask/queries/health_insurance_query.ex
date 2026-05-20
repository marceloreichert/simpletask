defmodule Simpletask.Queries.HealthInsuranceQuery do
  import Ecto.Query, warn: false
  alias Simpletask.Repo
  alias Simpletask.Schemas.HealthInsuranceSchema

  def list_health_insurances do
    HealthInsuranceSchema |> order_by([h], h.name) |> Repo.all()
  end

  def get_health_insurance!(id), do: Repo.get!(HealthInsuranceSchema, id)

  def create_health_insurance(attrs \\ %{}) do
    %HealthInsuranceSchema{}
    |> HealthInsuranceSchema.changeset(attrs)
    |> Repo.insert()
  end

  def update_health_insurance(%HealthInsuranceSchema{} = health_insurance, attrs) do
    health_insurance
    |> HealthInsuranceSchema.changeset(attrs)
    |> Repo.update()
  end

  def delete_health_insurance(%HealthInsuranceSchema{} = health_insurance) do
    Repo.delete(health_insurance)
  end

  def change_health_insurance(%HealthInsuranceSchema{} = health_insurance, attrs \\ %{}) do
    HealthInsuranceSchema.changeset(health_insurance, attrs)
  end
end
