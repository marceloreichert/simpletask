defmodule Simpletask.Repo.Migrations.AddProfessionalTypeIdToProfessionals do
  use Ecto.Migration

  def change do
    alter table(:professionals) do
      add :professional_type_id, references(:professional_types, type: :binary_id, on_delete: :nilify_all)
    end
  end
end
