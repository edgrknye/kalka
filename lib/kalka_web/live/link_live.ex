defmodule KalkaWeb.LinkLive do
  use KalkaWeb, :live_view

  use Phoenix.HTML
  import KalkaWeb.ErrorHelpers

  alias Kalka.Shortener
  alias Kalka.Shortener.Link
  require Logger

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:changeset, Shortener.change_link(%Link{}))
      |> assign(:shortlink, "")

    {:ok, socket}
    # {:ok, assign(socket, %{changeset: Shortener.change_link(%Link{}), shortlink: ""})}
  end

  def render(assigns) do
    ~L"""
    <%= form_for @changeset, "#", [phx_change: :validate, phx_submit: :create_link], fn f -> %>
    <div>
     <%= label f, :url %>
     <%= text_input f, :url %>
     <%= error_tag f, :url %>
    </div>

    <div>
    <%= label f, :slug, "Preferred Short Link" %>
    <%= text_input f, :slug %>
    <%= error_tag f, :slug %>
    </div>

    <button type="submit" phx-disable-with="">Generate</button>
    <% end %>
    """
  end

  def handle_event("validate", %{"link" => link_params}, socket) do
    changeset =
      %Link{}
      |> Shortener.change_link(link_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("create_link", %{"link" => link_params}, socket) do
    case Shortener.create_link(link_params) do
      {:ok, link} -> {:noreply, assign(socket, :shortlink, link.slug)}
      {:error, %Ecto.Changeset{} = changeset} -> {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
