defmodule KalkaWeb.LinkController do
  use KalkaWeb, :controller

  alias Kalka.Shortener
  alias Kalka.Shortener.Link

  action_fallback KalkaWeb.FallbackController

  def index(conn, _params) do
    links = Shortener.list_links()
    render(conn, "index.json", links: links)
  end

  def create(conn, %{"link" => link_params}) do
    with {:ok, %Link{} = link} <- Shortener.create_link(link_params) do
      conn
      |> put_status(:created)
      |> render("show.json", link: link)
    end
  end

  def show(conn, %{"id" => id}) do
    link = Shortener.get_link!(id)
    render(conn, "show.json", link: link)
  end

  def delete(conn, %{"id" => id}) do
    link = Shortener.get_link!(id)

    with {:ok, %Link{}} <- Shortener.delete_link(link) do
      send_resp(conn, :no_content, "")
    end
  end
end
