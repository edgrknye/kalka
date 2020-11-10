defmodule Kalka.Shortener.Link do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kalka.Shortener

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
    |> generate_slug()
    |> unique_constraint(:slug)
  end

  def generate_slug(changeset) do
    case fetch_change(changeset, :slug) do
      {:ok, _} ->
        changeset

      :error ->
        changeset
        |> put_change(:slug, do_generate_slug())
    end
  end

  defp do_generate_slug(length \\ 6, retries \\ 8)
  defp do_generate_slug(_, 0), do: nil

  defp do_generate_slug(length, retries) do
    slug = Enum.map(1..length, fn _ -> Enum.random(character_set()) end) |> Enum.join()

    if slug_unique?(slug) do
      slug
    else
      do_generate_slug(length, retries - 1)
    end
  end

  defp slug_unique?(slug), do: is_nil(Shortener.get_link_by(%{slug: slug}))

  defp character_set() do
    capitals = ?A..?Z |> Enum.map(fn ch -> <<ch>> end)
    lowers = ?a..?z |> Enum.map(fn ch -> <<ch>> end)
    numbers = 0..9 |> Enum.to_list()

    cutset = ["I", "l", "o", "O", 0]

    (capitals ++ lowers ++ numbers) -- cutset
  end
end
