defmodule KalkaWeb.StatelessComponent do
  use KalkaWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:title, "initial")

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div>
      <%= live_component @socket, KalkaWeb.TitleComponent, title: @title %>
    </div>
    """
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("set_title", %{"heading" => %{"title" => title}}, socket) do
    {:noreply, assign(socket, %{title: title})}
  end
end
