defmodule Kalka.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string, null: false
      add :slug, :string, null: false

      timestamps()
    end

    create index(:links, [:slug], unique: true)
  end
end
