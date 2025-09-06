defmodule Simpletask.PatientsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Simpletask.Patients` context.
  """

  @doc """
  Generate a patient.
  """
  def patient_fixture(attrs \\ %{}) do
    {:ok, patient} =
      attrs
      |> Enum.into(%{
        address_city: "some address_city",
        address_complement: "some address_complement",
        address_country: "some address_country",
        address_description: "some address_description",
        address_district: "some address_district",
        address_number: "some address_number",
        address_type: "some address_type",
        address_uf: "some address_uf",
        address_zip: "some address_zip",
        birthday: ~D[2025-02-11],
        country_of_naturalization: "some country_of_naturalization",
        date_of_naturalization: ~D[2025-02-11],
        document_cns: "some document_cns",
        document_cpf: "some document_cpf",
        document_id_issue_date: ~D[2025-02-11],
        document_id_issuer: "some document_id_issuer",
        document_id_number: "some document_id_number",
        document_id_uf: "some document_id_uf",
        document_passport_expiration_date: ~D[2025-02-11],
        document_passport_issue_country: "some document_passport_issue_country",
        document_passport_issue_date: ~D[2025-02-11],
        document_passport_number: "some document_passport_number",
        email: "some email",
        legal_person: "some legal_person",
        local_of_birth: "some local_of_birth",
        mothers_name: "some mothers_name",
        nacionality: "some nacionality",
        name: "some name",
        phone_ddd: "some phone_ddd",
        phone_number: "some phone_number",
        phone_type: "some phone_type",
        social_name: "some social_name"
      })
      |> Simpletask.Patients.create_patient()

    patient
  end
end
