defmodule SimpletaskWeb.ProfessionalLiveTest do
  use SimpletaskWeb.ConnCase

  import Phoenix.LiveViewTest
  import Simpletask.ProfessionalsFixtures

  @create_attrs %{
    phone_ddd: "some phone_ddd",
    document_passport_issue_country: "some document_passport_issue_country",
    document_id_issue_date: "2025-02-08",
    address_zip: "some address_zip",
    address_complement: "some address_complement",
    document_professional_uf: "some document_professional_uf",
    document_professional_number: "some document_professional_number",
    local_of_birth: "some local_of_birth",
    document_passport_expiration_date: "2025-02-08",
    address_description: "some address_description",
    date_of_naturalization: "2025-02-08",
    document_passport_issue_date: "2025-02-08",
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
    birthday: "2025-02-08",
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
    document_proffesional_type: "some document_proffesional_type"
  }
  @update_attrs %{
    phone_ddd: "some updated phone_ddd",
    document_passport_issue_country: "some updated document_passport_issue_country",
    document_id_issue_date: "2025-02-09",
    address_zip: "some updated address_zip",
    address_complement: "some updated address_complement",
    document_professional_uf: "some updated document_professional_uf",
    document_professional_number: "some updated document_professional_number",
    local_of_birth: "some updated local_of_birth",
    document_passport_expiration_date: "2025-02-09",
    address_description: "some updated address_description",
    date_of_naturalization: "2025-02-09",
    document_passport_issue_date: "2025-02-09",
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
    birthday: "2025-02-09",
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
    document_proffesional_type: "some updated document_proffesional_type"
  }
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
    document_proffesional_type: nil
  }

  defp create_professional(_) do
    professional = professional_fixture()
    %{professional: professional}
  end

  describe "Index" do
    setup [:create_professional]

    test "lists all professional", %{conn: conn, professional: professional} do
      {:ok, _index_live, html} = live(conn, ~p"/professionals")

      assert html =~ "Listing Professional"
      assert html =~ professional.phone_ddd
    end

    test "saves new professional", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/professionals")

      assert index_live |> element("a", "New Professional") |> render_click() =~
               "New Professional"

      assert_patch(index_live, ~p"/professionals/new")

      assert index_live
             |> form("#professional-form", professional: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#professional-form", professional: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/professionals")

      html = render(index_live)
      assert html =~ "Professional created successfully"
      assert html =~ "some phone_ddd"
    end

    test "updates professional in listing", %{conn: conn, professional: professional} do
      {:ok, index_live, _html} = live(conn, ~p"/professionals")

      assert index_live |> element("#professional-#{professional.id} a", "Edit") |> render_click() =~
               "Edit Professional"

      assert_patch(index_live, ~p"/professionals/#{professional}/edit")

      assert index_live
             |> form("#professional-form", professional: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#professional-form", professional: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/professionals")

      html = render(index_live)
      assert html =~ "Professional updated successfully"
      assert html =~ "some updated phone_ddd"
    end

    test "deletes professional in listing", %{conn: conn, professional: professional} do
      {:ok, index_live, _html} = live(conn, ~p"/professionals")

      assert index_live
             |> element("#professional-#{professional.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#professional-#{professional.id}")
    end
  end

  describe "Show" do
    setup [:create_professional]

    test "displays professional", %{conn: conn, professional: professional} do
      {:ok, _show_live, html} = live(conn, ~p"/professionals/#{professional}")

      assert html =~ "Show Professional"
      assert html =~ professional.phone_ddd
    end

    test "updates professional within modal", %{conn: conn, professional: professional} do
      {:ok, show_live, _html} = live(conn, ~p"/professionals/#{professional}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Professional"

      assert_patch(show_live, ~p"/professionals/#{professional}/show/edit")

      assert show_live
             |> form("#professional-form", professional: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#professional-form", professional: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/professionals/#{professional}")

      html = render(show_live)
      assert html =~ "Professional updated successfully"
      assert html =~ "some updated phone_ddd"
    end
  end
end
