defmodule Kalka.Shortener.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :slug, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :slug])
    |> validate_required([:url])
    |> validate_format(:slug, ~r/\A[-a-zA-Z0-9_]+\z/,
      message: "can only contain only numbers, letters, dashes and underscores"
    )
    |> validate_format(:url, UrlHelper.regex(), message: "invalid URL")
    |> validate_length(:slug, min: 3, max: 10)
    |> unique_constraint(:slug)
  end
end
