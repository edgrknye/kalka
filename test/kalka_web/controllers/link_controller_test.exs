defmodule KalkaWeb.LinkControllerTest do
  use KalkaWeb.ConnCase

  @create_attrs %{url: "http://example.com", slug: "slugg"}
  @invalid_attrs %{url: "just a string"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all links", %{conn: conn} do
      conn = get(conn, Routes.link_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "list all links when available", %{conn: conn} do
      insert(:link)
      conn = get(conn, Routes.link_path(conn, :index))

      assert data = json_response(conn, 200)["data"]
      assert length(data) == 1
    end
  end

  describe "create link" do
    test "creates a link when given both the slug and the url", %{conn: conn} do
      conn = post(conn, Routes.link_path(conn, :create), link: @create_attrs)

      assert %{} = data = json_response(conn, :created)
      assert data["url"] == @create_attrs["url"]
      assert data["slug"] == @create_attrs["slug"]
    end

    test "creates a link when only given a url", %{conn: conn} do
      conn = post(conn, Routes.link_path(conn, :create), link: %{url: "https://google.com"})

      assert %{} = data = json_response(conn, :created)["data"]
      assert data["url"] == "https://google.com"
      assert data["slug"] != ""
    end

    test "returns an error when the given url is invalid", %{conn: conn} do
      conn = post(conn, Routes.link_path(conn, :create), link: @invalid_attrs)

      assert %{} = data = json_response(conn, :unprocessable_entity)
      assert data["errors"] == %{"url" => ["invalid URL"]}
    end
  end

  describe "delete link" do
    test "deletes chosen link", %{conn: conn} do
      link = insert(:link)
      conn = delete(conn, Routes.link_path(conn, :delete, link))
      assert response(conn, :no_content)

      assert_error_sent :not_found, fn ->
        get(conn, Routes.link_path(conn, :show, link))
      end
    end
  end
end
