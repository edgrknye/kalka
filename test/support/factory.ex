defmodule Kalka.Factory do
  use ExMachina.Ecto, repo: Kalka.Repo

  def link_factory do
    %Kalka.Shortener.Link{
      url: "https://example.com",
      slug: sequence(:slug, &"slug#{&1}")
    }
  end
end
