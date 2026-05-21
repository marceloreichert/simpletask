defmodule Simpletask.Repo.Migrations.AddPrivateConsultationPriceToProfessionals do
  use Ecto.Migration

  def change do
    alter table(:professionals) do
      add :private_consultation_price, :decimal, precision: 10, scale: 2
    end
  end
end
