defmodule SimpletaskWeb.ModalityLiveTest do
  use SimpletaskWeb.ConnCase

  import Phoenix.LiveViewTest
  import Simpletask.ModalitiesFixtures

  @create_attrs %{name: "some name", unit_id: "some unit_id"}
  @update_attrs %{name: "some updated name", unit_id: "some updated unit_id"}
  @invalid_attrs %{name: nil, unit_id: nil}

  defp create_modality(_) do
    modality = modality_fixture()
    %{modality: modality}
  end

  describe "Index" do
    setup [:create_modality]

    test "lists all modalities", %{conn: conn, modality: modality} do
      {:ok, _index_live, html} = live(conn, ~p"/modalities")

      assert html =~ "Listing Modalities"
      assert html =~ modality.name
    end

    test "saves new modality", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/modalities")

      assert index_live |> element("a", "New Modality") |> render_click() =~
               "New Modality"

      assert_patch(index_live, ~p"/modalities/new")

      assert index_live
             |> form("#modality-form", modality: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#modality-form", modality: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/modalities")

      html = render(index_live)
      assert html =~ "Modality created successfully"
      assert html =~ "some name"
    end

    test "updates modality in listing", %{conn: conn, modality: modality} do
      {:ok, index_live, _html} = live(conn, ~p"/modalities")

      assert index_live |> element("#modalities-#{modality.id} a", "Edit") |> render_click() =~
               "Edit Modality"

      assert_patch(index_live, ~p"/modalities/#{modality}/edit")

      assert index_live
             |> form("#modality-form", modality: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#modality-form", modality: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/modalities")

      html = render(index_live)
      assert html =~ "Modality updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes modality in listing", %{conn: conn, modality: modality} do
      {:ok, index_live, _html} = live(conn, ~p"/modalities")

      assert index_live |> element("#modalities-#{modality.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#modalities-#{modality.id}")
    end
  end

  describe "Show" do
    setup [:create_modality]

    test "displays modality", %{conn: conn, modality: modality} do
      {:ok, _show_live, html} = live(conn, ~p"/modalities/#{modality}")

      assert html =~ "Show Modality"
      assert html =~ modality.name
    end

    test "updates modality within modal", %{conn: conn, modality: modality} do
      {:ok, show_live, _html} = live(conn, ~p"/modalities/#{modality}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Modality"

      assert_patch(show_live, ~p"/modalities/#{modality}/show/edit")

      assert show_live
             |> form("#modality-form", modality: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#modality-form", modality: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/modalities/#{modality}")

      html = render(show_live)
      assert html =~ "Modality updated successfully"
      assert html =~ "some updated name"
    end
  end
end
