defmodule Simpletask.PatientsTest do
  use Simpletask.DataCase

  alias Simpletask.Patients

  describe "patient" do
    alias Simpletask.Patients.Patient

    import Simpletask.PatientsFixtures

    @invalid_attrs %{name: nil, social_name: nil, mothers_name: nil, birthday: nil, nacionality: nil, local_of_birth: nil, date_of_naturalization: nil, country_of_naturalization: nil, document_passport_number: nil, document_passport_issue_date: nil, document_passport_issue_country: nil, document_passport_expiration_date: nil, email: nil, phone_type: nil, phone_ddd: nil, phone_number: nil, address_type: nil, address_description: nil, address_number: nil, address_complement: nil, address_district: nil, address_city: nil, address_uf: nil, address_country: nil, address_zip: nil, document_cpf: nil, document_id_number: nil, document_id_uf: nil, document_id_issuer: nil, document_id_issue_date: nil, document_cns: nil, legal_person: nil}

    test "list_patient/0 returns all patient" do
      patient = patient_fixture()
      assert Patients.list_patient() == [patient]
    end

    test "get_patient!/1 returns the patient with given id" do
      patient = patient_fixture()
      assert Patients.get_patient!(patient.id) == patient
    end

    test "create_patient/1 with valid data creates a patient" do
      valid_attrs = %{name: "some name", social_name: "some social_name", mothers_name: "some mothers_name", birthday: ~D[2025-02-11], nacionality: "some nacionality", local_of_birth: "some local_of_birth", date_of_naturalization: ~D[2025-02-11], country_of_naturalization: "some country_of_naturalization", document_passport_number: "some document_passport_number", document_passport_issue_date: ~D[2025-02-11], document_passport_issue_country: "some document_passport_issue_country", document_passport_expiration_date: ~D[2025-02-11], email: "some email", phone_type: "some phone_type", phone_ddd: "some phone_ddd", phone_number: "some phone_number", address_type: "some address_type", address_description: "some address_description", address_number: "some address_number", address_complement: "some address_complement", address_district: "some address_district", address_city: "some address_city", address_uf: "some address_uf", address_country: "some address_country", address_zip: "some address_zip", document_cpf: "some document_cpf", document_id_number: "some document_id_number", document_id_uf: "some document_id_uf", document_id_issuer: "some document_id_issuer", document_id_issue_date: ~D[2025-02-11], document_cns: "some document_cns", legal_person: "some legal_person"}

      assert {:ok, %Patient{} = patient} = Patients.create_patient(valid_attrs)
      assert patient.name == "some name"
      assert patient.social_name == "some social_name"
      assert patient.mothers_name == "some mothers_name"
      assert patient.birthday == ~D[2025-02-11]
      assert patient.nacionality == "some nacionality"
      assert patient.local_of_birth == "some local_of_birth"
      assert patient.date_of_naturalization == ~D[2025-02-11]
      assert patient.country_of_naturalization == "some country_of_naturalization"
      assert patient.document_passport_number == "some document_passport_number"
      assert patient.document_passport_issue_date == ~D[2025-02-11]
      assert patient.document_passport_issue_country == "some document_passport_issue_country"
      assert patient.document_passport_expiration_date == ~D[2025-02-11]
      assert patient.email == "some email"
      assert patient.phone_type == "some phone_type"
      assert patient.phone_ddd == "some phone_ddd"
      assert patient.phone_number == "some phone_number"
      assert patient.address_type == "some address_type"
      assert patient.address_description == "some address_description"
      assert patient.address_number == "some address_number"
      assert patient.address_complement == "some address_complement"
      assert patient.address_district == "some address_district"
      assert patient.address_city == "some address_city"
      assert patient.address_uf == "some address_uf"
      assert patient.address_country == "some address_country"
      assert patient.address_zip == "some address_zip"
      assert patient.document_cpf == "some document_cpf"
      assert patient.document_id_number == "some document_id_number"
      assert patient.document_id_uf == "some document_id_uf"
      assert patient.document_id_issuer == "some document_id_issuer"
      assert patient.document_id_issue_date == ~D[2025-02-11]
      assert patient.document_cns == "some document_cns"
      assert patient.legal_person == "some legal_person"
    end

    test "create_patient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Patients.create_patient(@invalid_attrs)
    end

    test "update_patient/2 with valid data updates the patient" do
      patient = patient_fixture()
      update_attrs = %{name: "some updated name", social_name: "some updated social_name", mothers_name: "some updated mothers_name", birthday: ~D[2025-02-12], nacionality: "some updated nacionality", local_of_birth: "some updated local_of_birth", date_of_naturalization: ~D[2025-02-12], country_of_naturalization: "some updated country_of_naturalization", document_passport_number: "some updated document_passport_number", document_passport_issue_date: ~D[2025-02-12], document_passport_issue_country: "some updated document_passport_issue_country", document_passport_expiration_date: ~D[2025-02-12], email: "some updated email", phone_type: "some updated phone_type", phone_ddd: "some updated phone_ddd", phone_number: "some updated phone_number", address_type: "some updated address_type", address_description: "some updated address_description", address_number: "some updated address_number", address_complement: "some updated address_complement", address_district: "some updated address_district", address_city: "some updated address_city", address_uf: "some updated address_uf", address_country: "some updated address_country", address_zip: "some updated address_zip", document_cpf: "some updated document_cpf", document_id_number: "some updated document_id_number", document_id_uf: "some updated document_id_uf", document_id_issuer: "some updated document_id_issuer", document_id_issue_date: ~D[2025-02-12], document_cns: "some updated document_cns", legal_person: "some updated legal_person"}

      assert {:ok, %Patient{} = patient} = Patients.update_patient(patient, update_attrs)
      assert patient.name == "some updated name"
      assert patient.social_name == "some updated social_name"
      assert patient.mothers_name == "some updated mothers_name"
      assert patient.birthday == ~D[2025-02-12]
      assert patient.nacionality == "some updated nacionality"
      assert patient.local_of_birth == "some updated local_of_birth"
      assert patient.date_of_naturalization == ~D[2025-02-12]
      assert patient.country_of_naturalization == "some updated country_of_naturalization"
      assert patient.document_passport_number == "some updated document_passport_number"
      assert patient.document_passport_issue_date == ~D[2025-02-12]
      assert patient.document_passport_issue_country == "some updated document_passport_issue_country"
      assert patient.document_passport_expiration_date == ~D[2025-02-12]
      assert patient.email == "some updated email"
      assert patient.phone_type == "some updated phone_type"
      assert patient.phone_ddd == "some updated phone_ddd"
      assert patient.phone_number == "some updated phone_number"
      assert patient.address_type == "some updated address_type"
      assert patient.address_description == "some updated address_description"
      assert patient.address_number == "some updated address_number"
      assert patient.address_complement == "some updated address_complement"
      assert patient.address_district == "some updated address_district"
      assert patient.address_city == "some updated address_city"
      assert patient.address_uf == "some updated address_uf"
      assert patient.address_country == "some updated address_country"
      assert patient.address_zip == "some updated address_zip"
      assert patient.document_cpf == "some updated document_cpf"
      assert patient.document_id_number == "some updated document_id_number"
      assert patient.document_id_uf == "some updated document_id_uf"
      assert patient.document_id_issuer == "some updated document_id_issuer"
      assert patient.document_id_issue_date == ~D[2025-02-12]
      assert patient.document_cns == "some updated document_cns"
      assert patient.legal_person == "some updated legal_person"
    end

    test "update_patient/2 with invalid data returns error changeset" do
      patient = patient_fixture()
      assert {:error, %Ecto.Changeset{}} = Patients.update_patient(patient, @invalid_attrs)
      assert patient == Patients.get_patient!(patient.id)
    end

    test "delete_patient/1 deletes the patient" do
      patient = patient_fixture()
      assert {:ok, %Patient{}} = Patients.delete_patient(patient)
      assert_raise Ecto.NoResultsError, fn -> Patients.get_patient!(patient.id) end
    end

    test "change_patient/1 returns a patient changeset" do
      patient = patient_fixture()
      assert %Ecto.Changeset{} = Patients.change_patient(patient)
    end
  end
end
