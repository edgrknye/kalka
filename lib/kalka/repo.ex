defmodule Kalka.Repo do
  use Ecto.Repo,
    otp_app: :kalka,
    adapter: Ecto.Adapters.Postgres
end
