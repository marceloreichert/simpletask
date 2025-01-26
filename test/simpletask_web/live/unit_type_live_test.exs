defmodule SimpletaskWeb.UnitTypeLiveTest do
  use SimpletaskWeb.ConnCase

  import Phoenix.LiveViewTest
  import Simpletask.UnitTypesFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_unit_type(_) do
    unit_type = unit_type_fixture()
    %{unit_type: unit_type}
  end

  describe "Index" do
    setup [:create_unit_type]

    test "lists all unit_types", %{conn: conn, unit_type: unit_type} do
      {:ok, _index_live, html} = live(conn, ~p"/unit_types")

      assert html =~ "Listing Unit types"
      assert html =~ unit_type.name
    end

    test "saves new unit_type", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/unit_types")

      assert index_live |> element("a", "New Unit type") |> render_click() =~
               "New Unit type"

      assert_patch(index_live, ~p"/unit_types/new")

      assert index_live
             |> form("#unit_type-form", unit_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#unit_type-form", unit_type: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/unit_types")

      html = render(index_live)
      assert html =~ "Unit type created successfully"
      assert html =~ "some name"
    end

    test "updates unit_type in listing", %{conn: conn, unit_type: unit_type} do
      {:ok, index_live, _html} = live(conn, ~p"/unit_types")

      assert index_live |> element("#unit_types-#{unit_type.id} a", "Edit") |> render_click() =~
               "Edit Unit type"

      assert_patch(index_live, ~p"/unit_types/#{unit_type}/edit")

      assert index_live
             |> form("#unit_type-form", unit_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#unit_type-form", unit_type: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/unit_types")

      html = render(index_live)
      assert html =~ "Unit type updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes unit_type in listing", %{conn: conn, unit_type: unit_type} do
      {:ok, index_live, _html} = live(conn, ~p"/unit_types")

      assert index_live |> element("#unit_types-#{unit_type.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#unit_types-#{unit_type.id}")
    end
  end

  describe "Show" do
    setup [:create_unit_type]

    test "displays unit_type", %{conn: conn, unit_type: unit_type} do
      {:ok, _show_live, html} = live(conn, ~p"/unit_types/#{unit_type}")

      assert html =~ "Show Unit type"
      assert html =~ unit_type.name
    end

    test "updates unit_type within modal", %{conn: conn, unit_type: unit_type} do
      {:ok, show_live, _html} = live(conn, ~p"/unit_types/#{unit_type}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Unit type"

      assert_patch(show_live, ~p"/unit_types/#{unit_type}/show/edit")

      assert show_live
             |> form("#unit_type-form", unit_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#unit_type-form", unit_type: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/unit_types/#{unit_type}")

      html = render(show_live)
      assert html =~ "Unit type updated successfully"
      assert html =~ "some updated name"
    end
  end
end
