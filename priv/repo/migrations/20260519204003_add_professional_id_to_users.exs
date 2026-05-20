defmodule Simpletask.Repo.Migrations.AddProfessionalIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :professional_id, references(:professionals, type: :uuid, on_delete: :nilify_all), null: true
    end
  end
end
