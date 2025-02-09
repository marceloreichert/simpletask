defmodule SimpletaskWeb.SpecialtyLiveTest do
  use SimpletaskWeb.ConnCase

  import Phoenix.LiveViewTest
  import Simpletask.SpecialtiesFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_specialty(_) do
    specialty = specialty_fixture()
    %{specialty: specialty}
  end

  describe "Index" do
    setup [:create_specialty]

    test "lists all specialties", %{conn: conn, specialty: specialty} do
      {:ok, _index_live, html} = live(conn, ~p"/specialties")

      assert html =~ "Listing Specialties"
      assert html =~ specialty.name
    end

    test "saves new specialty", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/specialties")

      assert index_live |> element("a", "New Specialty") |> render_click() =~
               "New Specialty"

      assert_patch(index_live, ~p"/specialties/new")

      assert index_live
             |> form("#specialty-form", specialty: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#specialty-form", specialty: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/specialties")

      html = render(index_live)
      assert html =~ "Specialty created successfully"
      assert html =~ "some name"
    end

    test "updates specialty in listing", %{conn: conn, specialty: specialty} do
      {:ok, index_live, _html} = live(conn, ~p"/specialties")

      assert index_live |> element("#specialties-#{specialty.id} a", "Edit") |> render_click() =~
               "Edit Specialty"

      assert_patch(index_live, ~p"/specialties/#{specialty}/edit")

      assert index_live
             |> form("#specialty-form", specialty: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#specialty-form", specialty: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/specialties")

      html = render(index_live)
      assert html =~ "Specialty updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes specialty in listing", %{conn: conn, specialty: specialty} do
      {:ok, index_live, _html} = live(conn, ~p"/specialties")

      assert index_live |> element("#specialties-#{specialty.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#specialties-#{specialty.id}")
    end
  end

  describe "Show" do
    setup [:create_specialty]

    test "displays specialty", %{conn: conn, specialty: specialty} do
      {:ok, _show_live, html} = live(conn, ~p"/specialties/#{specialty}")

      assert html =~ "Show Specialty"
      assert html =~ specialty.name
    end

    test "updates specialty within modal", %{conn: conn, specialty: specialty} do
      {:ok, show_live, _html} = live(conn, ~p"/specialties/#{specialty}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Specialty"

      assert_patch(show_live, ~p"/specialties/#{specialty}/show/edit")

      assert show_live
             |> form("#specialty-form", specialty: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#specialty-form", specialty: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/specialties/#{specialty}")

      html = render(show_live)
      assert html =~ "Specialty updated successfully"
      assert html =~ "some updated name"
    end
  end
end
