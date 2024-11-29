defmodule Twittex.Repo do
  use Ecto.Repo,
    otp_app: :twittex,
    adapter: Ecto.Adapters.Postgres
end
