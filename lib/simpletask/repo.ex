defmodule Simpletask.Repo do
  use Ecto.Repo,
    otp_app: :simpletask,
    adapter: Ecto.Adapters.Postgres
end
