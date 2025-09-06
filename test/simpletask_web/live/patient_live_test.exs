defmodule SimpletaskWeb.PatientLiveTest do
  use SimpletaskWeb.ConnCase

  import Phoenix.LiveViewTest
  import Simpletask.PatientsFixtures

  @create_attrs %{name: "some name", social_name: "some social_name", mothers_name: "some mothers_name", birthday: "2025-02-11", nacionality: "some nacionality", local_of_birth: "some local_of_birth", date_of_naturalization: "2025-02-11", country_of_naturalization: "some country_of_naturalization", document_passport_number: "some document_passport_number", document_passport_issue_date: "2025-02-11", document_passport_issue_country: "some document_passport_issue_country", document_passport_expiration_date: "2025-02-11", email: "some email", phone_type: "some phone_type", phone_ddd: "some phone_ddd", phone_number: "some phone_number", address_type: "some address_type", address_description: "some address_description", address_number: "some address_number", address_complement: "some address_complement", address_district: "some address_district", address_city: "some address_city", address_uf: "some address_uf", address_country: "some address_country", address_zip: "some address_zip", document_cpf: "some document_cpf", document_id_number: "some document_id_number", document_id_uf: "some document_id_uf", document_id_issuer: "some document_id_issuer", document_id_issue_date: "2025-02-11", document_cns: "some document_cns", legal_person: "some legal_person"}
  @update_attrs %{name: "some updated name", social_name: "some updated social_name", mothers_name: "some updated mothers_name", birthday: "2025-02-12", nacionality: "some updated nacionality", local_of_birth: "some updated local_of_birth", date_of_naturalization: "2025-02-12", country_of_naturalization: "some updated country_of_naturalization", document_passport_number: "some updated document_passport_number", document_passport_issue_date: "2025-02-12", document_passport_issue_country: "some updated document_passport_issue_country", document_passport_expiration_date: "2025-02-12", email: "some updated email", phone_type: "some updated phone_type", phone_ddd: "some updated phone_ddd", phone_number: "some updated phone_number", address_type: "some updated address_type", address_description: "some updated address_description", address_number: "some updated address_number", address_complement: "some updated address_complement", address_district: "some updated address_district", address_city: "some updated address_city", address_uf: "some updated address_uf", address_country: "some updated address_country", address_zip: "some updated address_zip", document_cpf: "some updated document_cpf", document_id_number: "some updated document_id_number", document_id_uf: "some updated document_id_uf", document_id_issuer: "some updated document_id_issuer", document_id_issue_date: "2025-02-12", document_cns: "some updated document_cns", legal_person: "some updated legal_person"}
  @invalid_attrs %{name: nil, social_name: nil, mothers_name: nil, birthday: nil, nacionality: nil, local_of_birth: nil, date_of_naturalization: nil, country_of_naturalization: nil, document_passport_number: nil, document_passport_issue_date: nil, document_passport_issue_country: nil, document_passport_expiration_date: nil, email: nil, phone_type: nil, phone_ddd: nil, phone_number: nil, address_type: nil, address_description: nil, address_number: nil, address_complement: nil, address_district: nil, address_city: nil, address_uf: nil, address_country: nil, address_zip: nil, document_cpf: nil, document_id_number: nil, document_id_uf: nil, document_id_issuer: nil, document_id_issue_date: nil, document_cns: nil, legal_person: nil}

  defp create_patient(_) do
    patient = patient_fixture()
    %{patient: patient}
  end

  describe "Index" do
    setup [:create_patient]

    test "lists all patient", %{conn: conn, patient: patient} do
      {:ok, _index_live, html} = live(conn, ~p"/patient")

      assert html =~ "Listing Patient"
      assert html =~ patient.name
    end

    test "saves new patient", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/patient")

      assert index_live |> element("a", "New Patient") |> render_click() =~
               "New Patient"

      assert_patch(index_live, ~p"/patient/new")

      assert index_live
             |> form("#patient-form", patient: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#patient-form", patient: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/patient")

      html = render(index_live)
      assert html =~ "Patient created successfully"
      assert html =~ "some name"
    end

    test "updates patient in listing", %{conn: conn, patient: patient} do
      {:ok, index_live, _html} = live(conn, ~p"/patient")

      assert index_live |> element("#patient-#{patient.id} a", "Edit") |> render_click() =~
               "Edit Patient"

      assert_patch(index_live, ~p"/patient/#{patient}/edit")

      assert index_live
             |> form("#patient-form", patient: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#patient-form", patient: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/patient")

      html = render(index_live)
      assert html =~ "Patient updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes patient in listing", %{conn: conn, patient: patient} do
      {:ok, index_live, _html} = live(conn, ~p"/patient")

      assert index_live |> element("#patient-#{patient.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#patient-#{patient.id}")
    end
  end

  describe "Show" do
    setup [:create_patient]

    test "displays patient", %{conn: conn, patient: patient} do
      {:ok, _show_live, html} = live(conn, ~p"/patient/#{patient}")

      assert html =~ "Show Patient"
      assert html =~ patient.name
    end

    test "updates patient within modal", %{conn: conn, patient: patient} do
      {:ok, show_live, _html} = live(conn, ~p"/patient/#{patient}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Patient"

      assert_patch(show_live, ~p"/patient/#{patient}/show/edit")

      assert show_live
             |> form("#patient-form", patient: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#patient-form", patient: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/patient/#{patient}")

      html = render(show_live)
      assert html =~ "Patient updated successfully"
      assert html =~ "some updated name"
    end
  end
end
