defmodule Kalka.ShortenerTest do
  use Kalka.DataCase

  alias Kalka.Shortener
  alias Kalka.Shortener.Link

  # using factories instead of fixtures
  import Kalka.Factory

  describe "list_links/0" do
    test "returns all links currently saved in the db" do
      link = insert(:link)
      assert Shortener.list_links() == [link]
    end

    test "returns an empty list when no links are saved" do
      assert Shortener.list_links() == []
    end
  end

  describe "get_link!/1" do
    test "when given a valid id returns a corresponding link" do
      link = insert(:link)
      assert Shortener.get_link!(link.id) == link
    end

    test "when given id is invalid, raises an error" do
      assert_raise Ecto.NoResultsError, fn -> Shortener.get_link!(100) end
    end
  end

  describe "get_link_by/1" do
    test "returns a link referenced by specified attribute" do
      google_link = insert(:link, url: "https://google.com", slug: "google")
      twitter_link = insert(:link, url: "https://twitter.com", slug: "twitter")

      assert Shortener.get_link_by(slug: google_link.slug) == google_link
      assert Shortener.get_link_by(url: twitter_link.url) == twitter_link
    end

    test "returns nil when no existing link is targeted" do
      assert is_nil(Shortener.get_link_by(slug: "does-not-exist"))
    end
  end

  describe "create_link/1" do
    test "creates a link when given just the url" do
      assert {:ok, %Link{} = link} = Shortener.create_link(%{url: "https://example.com"})
      assert link.url == "https://example.com"
      assert link.slug != ""
    end

    test "creates a link when given both url and slug" do
      assert {:ok, %Link{} = link} =
               Shortener.create_link(%{url: "https://test.com", slug: "test"})

      assert link.url == "https://test.com"
      assert link.slug == "test"
    end

    test "fails when given url is invalid" do
      assert {:error, %Ecto.Changeset{} = changeset} = Shortener.create_link(%{url: "url"})
      assert errors_on(changeset).url == ["invalid URL"]
    end

    test "fails when given slug is less than 3 characters" do
      assert {:error, %Ecto.Changeset{} = changeset} =
               Shortener.create_link(%{url: "https://test.com", slug: "ab"})

      assert errors_on(changeset).slug == ["should be at least 3 character(s)"]
    end

    test "fails when given slug is longer than 10 characters" do
      assert {:error, %Ecto.Changeset{} = changeset} =
               Shortener.create_link(%{url: "https://test.com", slug: "to_long_a_slug"})

      assert errors_on(changeset).slug == ["should be at most 10 character(s)"]
    end

    test "fails when given slug has special characters" do
      assert {:error, %Ecto.Changeset{} = changeset} =
               Shortener.create_link(%{url: "https://test.com", slug: "Mv+L1s"})

      assert errors_on(changeset).slug == [
               "can only contain only numbers, letters, dashes and underscores"
             ]
    end

    test "fails when link with given slug already exists" do
      link = insert(:link)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Shortener.create_link(%{url: "https://twitter.com", slug: link.slug})

      assert errors_on(changeset).slug == ["has already been taken"]
    end
  end

  describe "delete_link/1" do
    test "deletes given link" do
      link = insert(:link)

      assert Shortener.list_links() == [link]

      assert {:ok, %Link{}} = Shortener.delete_link(link)

      assert Shortener.list_links() == []
      assert_raise Ecto.NoResultsError, fn -> Shortener.get_link!(link.id) end
    end
  end

  describe "change_link/1" do
    test "returns a changeset" do
      link = build(:link)

      assert %Ecto.Changeset{} = Shortener.change_link(link)
    end
  end
end
