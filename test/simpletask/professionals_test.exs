defmodule Simpletask.ProfessionalsTest do
  use Simpletask.DataCase

  alias Simpletask.Professionals

  describe "professional" do
    alias Simpletask.Professionals.Professional

    import Simpletask.ProfessionalsFixtures

    @invalid_attrs %{
      phone_ddd: nil,
      document_passport_issue_country: nil,
      document_id_issue_date: nil,
      address_zip: nil,
      address_complement: nil,
      document_professional_uf: nil,
      document_professional_number: nil,
      local_of_birth: nil,
      document_passport_expiration_date: nil,
      address_description: nil,
      date_of_naturalization: nil,
      document_passport_issue_date: nil,
      email: nil,
      country_of_naturalization: nil,
      phone_type: nil,
      document_id_issuer: nil,
      document_passport_number: nil,
      address_number: nil,
      address_country: nil,
      document_cpf: nil,
      document_id_uf: nil,
      address_district: nil,
      address_city: nil,
      cbo_code: nil,
      birthday: nil,
      address_uf: nil,
      cbo_description: nil,
      cbo_name: nil,
      address_type: nil,
      name: nil,
      document_id_number: nil,
      mothers_name: nil,
      phone_number: nil,
      document_cns: nil,
      nacionality: nil,
      social_name: nil,
      document_professional_type: nil
    }

    test "list_professional/0 returns all professional" do
      professional = professional_fixture()
      assert Professionals.list_professional() == [professional]
    end

    test "get_professional!/1 returns the professional with given id" do
      professional = professional_fixture()
      assert Professionals.get_professional!(professional.id) == professional
    end

    test "create_professional/1 with valid data creates a professional" do
      valid_attrs = %{
        phone_ddd: "some phone_ddd",
        document_passport_issue_country: "some document_passport_issue_country",
        document_id_issue_date: ~D[2025-02-08],
        address_zip: "some address_zip",
        address_complement: "some address_complement",
        document_professional_uf: "some document_professional_uf",
        document_professional_number: "some document_professional_number",
        local_of_birth: "some local_of_birth",
        document_passport_expiration_date: ~D[2025-02-08],
        address_description: "some address_description",
        date_of_naturalization: ~D[2025-02-08],
        document_passport_issue_date: ~D[2025-02-08],
        email: "some email",
        country_of_naturalization: "some country_of_naturalization",
        phone_type: "some phone_type",
        document_id_issuer: "some document_id_issuer",
        document_passport_number: "some document_passport_number",
        address_number: "some address_number",
        address_country: "some address_country",
        document_cpf: "some document_cpf",
        document_id_uf: "some document_id_uf",
        address_district: "some address_district",
        address_city: "some address_city",
        cbo_code: "some cbo_code",
        birthday: ~D[2025-02-08],
        address_uf: "some address_uf",
        cbo_description: "some cbo_description",
        cbo_name: "some cbo_name",
        address_type: "some address_type",
        name: "some name",
        document_id_number: "some document_id_number",
        mothers_name: "some mothers_name",
        phone_number: "some phone_number",
        document_cns: "some document_cns",
        nacionality: "some nacionality",
        social_name: "some social_name",
        document_professional_type: "some document_professional_type"
      }

      assert {:ok, %Professional{} = professional} =
               Professionals.create_professional(valid_attrs)

      assert professional.document_professional_type == "some document_professional_type"
      assert professional.social_name == "some social_name"
      assert professional.nacionality == "some nacionality"
      assert professional.document_cns == "some document_cns"
      assert professional.phone_number == "some phone_number"
      assert professional.mothers_name == "some mothers_name"
      assert professional.document_id_number == "some document_id_number"
      assert professional.name == "some name"
      assert professional.address_type == "some address_type"
      assert professional.cbo_name == "some cbo_name"
      assert professional.cbo_description == "some cbo_description"
      assert professional.address_uf == "some address_uf"
      assert professional.birthday == ~D[2025-02-08]
      assert professional.cbo_code == "some cbo_code"
      assert professional.address_city == "some address_city"
      assert professional.address_district == "some address_district"
      assert professional.document_id_uf == "some document_id_uf"
      assert professional.document_cpf == "some document_cpf"
      assert professional.address_country == "some address_country"
      assert professional.address_number == "some address_number"
      assert professional.document_passport_number == "some document_passport_number"
      assert professional.document_id_issuer == "some document_id_issuer"
      assert professional.phone_type == "some phone_type"
      assert professional.country_of_naturalization == "some country_of_naturalization"
      assert professional.email == "some email"
      assert professional.document_passport_issue_date == ~D[2025-02-08]
      assert professional.date_of_naturalization == ~D[2025-02-08]
      assert professional.address_description == "some address_description"
      assert professional.document_passport_expiration_date == ~D[2025-02-08]
      assert professional.local_of_birth == "some local_of_birth"
      assert professional.document_professional_number == "some document_professional_number"
      assert professional.document_professional_uf == "some document_professional_uf"
      assert professional.address_complement == "some address_complement"
      assert professional.address_zip == "some address_zip"
      assert professional.document_id_issue_date == ~D[2025-02-08]

      assert professional.document_passport_issue_country ==
               "some document_passport_issue_country"

      assert professional.phone_ddd == "some phone_ddd"
    end

    test "create_professional/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Professionals.create_professional(@invalid_attrs)
    end

    test "update_professional/2 with valid data updates the professional" do
      professional = professional_fixture()

      update_attrs = %{
        phone_ddd: "some updated phone_ddd",
        document_passport_issue_country: "some updated document_passport_issue_country",
        document_id_issue_date: ~D[2025-02-09],
        address_zip: "some updated address_zip",
        address_complement: "some updated address_complement",
        document_professional_uf: "some updated document_professional_uf",
        document_professional_number: "some updated document_professional_number",
        local_of_birth: "some updated local_of_birth",
        document_passport_expiration_date: ~D[2025-02-09],
        address_description: "some updated address_description",
        date_of_naturalization: ~D[2025-02-09],
        document_passport_issue_date: ~D[2025-02-09],
        email: "some updated email",
        country_of_naturalization: "some updated country_of_naturalization",
        phone_type: "some updated phone_type",
        document_id_issuer: "some updated document_id_issuer",
        document_passport_number: "some updated document_passport_number",
        address_number: "some updated address_number",
        address_country: "some updated address_country",
        document_cpf: "some updated document_cpf",
        document_id_uf: "some updated document_id_uf",
        address_district: "some updated address_district",
        address_city: "some updated address_city",
        cbo_code: "some updated cbo_code",
        birthday: ~D[2025-02-09],
        address_uf: "some updated address_uf",
        cbo_description: "some updated cbo_description",
        cbo_name: "some updated cbo_name",
        address_type: "some updated address_type",
        name: "some updated name",
        document_id_number: "some updated document_id_number",
        mothers_name: "some updated mothers_name",
        phone_number: "some updated phone_number",
        document_cns: "some updated document_cns",
        nacionality: "some updated nacionality",
        social_name: "some updated social_name",
        document_professional_type: "some updated document_professional_type"
      }

      assert {:ok, %Professional{} = professional} =
               Professionals.update_professional(professional, update_attrs)

      assert professional.document_professional_type == "some updated document_professional_type"
      assert professional.social_name == "some updated social_name"
      assert professional.nacionality == "some updated nacionality"
      assert professional.document_cns == "some updated document_cns"
      assert professional.phone_number == "some updated phone_number"
      assert professional.mothers_name == "some updated mothers_name"
      assert professional.document_id_number == "some updated document_id_number"
      assert professional.name == "some updated name"
      assert professional.address_type == "some updated address_type"
      assert professional.cbo_name == "some updated cbo_name"
      assert professional.cbo_description == "some updated cbo_description"
      assert professional.address_uf == "some updated address_uf"
      assert professional.birthday == ~D[2025-02-09]
      assert professional.cbo_code == "some updated cbo_code"
      assert professional.address_city == "some updated address_city"
      assert professional.address_district == "some updated address_district"
      assert professional.document_id_uf == "some updated document_id_uf"
      assert professional.document_cpf == "some updated document_cpf"
      assert professional.address_country == "some updated address_country"
      assert professional.address_number == "some updated address_number"
      assert professional.document_passport_number == "some updated document_passport_number"
      assert professional.document_id_issuer == "some updated document_id_issuer"
      assert professional.phone_type == "some updated phone_type"
      assert professional.country_of_naturalization == "some updated country_of_naturalization"
      assert professional.email == "some updated email"
      assert professional.document_passport_issue_date == ~D[2025-02-09]
      assert professional.date_of_naturalization == ~D[2025-02-09]
      assert professional.address_description == "some updated address_description"
      assert professional.document_passport_expiration_date == ~D[2025-02-09]
      assert professional.local_of_birth == "some updated local_of_birth"

      assert professional.document_professional_number ==
               "some updated document_professional_number"

      assert professional.document_professional_uf == "some updated document_professional_uf"
      assert professional.address_complement == "some updated address_complement"
      assert professional.address_zip == "some updated address_zip"
      assert professional.document_id_issue_date == ~D[2025-02-09]

      assert professional.document_passport_issue_country ==
               "some updated document_passport_issue_country"

      assert professional.phone_ddd == "some updated phone_ddd"
    end

    test "update_professional/2 with invalid data returns error changeset" do
      professional = professional_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Professionals.update_professional(professional, @invalid_attrs)

      assert professional == Professionals.get_professional!(professional.id)
    end

    test "delete_professional/1 deletes the professional" do
      professional = professional_fixture()
      assert {:ok, %Professional{}} = Professionals.delete_professional(professional)
      assert_raise Ecto.NoResultsError, fn -> Professionals.get_professional!(professional.id) end
    end

    test "change_professional/1 returns a professional changeset" do
      professional = professional_fixture()
      assert %Ecto.Changeset{} = Professionals.change_professional(professional)
    end
  end
end
