defmodule SimpletaskWeb.SectorLiveTest do
  use SimpletaskWeb.ConnCase

  import Phoenix.LiveViewTest
  import Simpletask.SectorsFixtures

  @create_attrs %{name: "some name", unit_id: "some unit_id"}
  @update_attrs %{name: "some updated name", unit_id: "some updated unit_id"}
  @invalid_attrs %{name: nil, unit_id: nil}

  defp create_sector(_) do
    sector = sector_fixture()
    %{sector: sector}
  end

  describe "Index" do
    setup [:create_sector]

    test "lists all sectors", %{conn: conn, sector: sector} do
      {:ok, _index_live, html} = live(conn, ~p"/sectors")

      assert html =~ "Listing Sectors"
      assert html =~ sector.name
    end

    test "saves new sector", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sectors")

      assert index_live |> element("a", "New Sector") |> render_click() =~
               "New Sector"

      assert_patch(index_live, ~p"/sectors/new")

      assert index_live
             |> form("#sector-form", sector: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#sector-form", sector: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sectors")

      html = render(index_live)
      assert html =~ "Sector created successfully"
      assert html =~ "some name"
    end

    test "updates sector in listing", %{conn: conn, sector: sector} do
      {:ok, index_live, _html} = live(conn, ~p"/sectors")

      assert index_live |> element("#sectors-#{sector.id} a", "Edit") |> render_click() =~
               "Edit Sector"

      assert_patch(index_live, ~p"/sectors/#{sector}/edit")

      assert index_live
             |> form("#sector-form", sector: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#sector-form", sector: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sectors")

      html = render(index_live)
      assert html =~ "Sector updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes sector in listing", %{conn: conn, sector: sector} do
      {:ok, index_live, _html} = live(conn, ~p"/sectors")

      assert index_live |> element("#sectors-#{sector.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#sectors-#{sector.id}")
    end
  end

  describe "Show" do
    setup [:create_sector]

    test "displays sector", %{conn: conn, sector: sector} do
      {:ok, _show_live, html} = live(conn, ~p"/sectors/#{sector}")

      assert html =~ "Show Sector"
      assert html =~ sector.name
    end

    test "updates sector within modal", %{conn: conn, sector: sector} do
      {:ok, show_live, _html} = live(conn, ~p"/sectors/#{sector}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Sector"

      assert_patch(show_live, ~p"/sectors/#{sector}/show/edit")

      assert show_live
             |> form("#sector-form", sector: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#sector-form", sector: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/sectors/#{sector}")

      html = render(show_live)
      assert html =~ "Sector updated successfully"
      assert html =~ "some updated name"
    end
  end
end
