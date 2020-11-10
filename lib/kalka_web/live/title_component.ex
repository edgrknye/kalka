defmodule KalkaWeb.TitleComponent do
  use KalkaWeb, :live_component

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h2><%= @title %> </h2>
    <div>
      <%= f = form_for :heading, "#", [phx_submit: :set_title] %>
        <%= label f, :title %>
        <%= text_input f, :title %>

        <%= submit  "Set" %>
      </form>
    </div>
    """
  end

  def update(%{title: title}, socket) do
    {:ok, assign(socket, %{title: title})}
  end
end
