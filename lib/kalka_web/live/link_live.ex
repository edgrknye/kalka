defmodule KalkaWeb.LinkLive do
  use KalkaWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  # def render(assigns) do
  #   ~L"""
  #   <% f = form_for @changeset, "#", [phx_change: :validate, phx_submit: :save] %>
  #    <%= label f, :url %>
  #    <%= text_input f, :url %>
  #    <%= error_tag f, :url %>

  #    <%= submit "Generate" %>
  #   </form>
  #   """
  # end

  def render(assigns) do
    ~L"""
    Phoenix is awesome
    """
  end
end
