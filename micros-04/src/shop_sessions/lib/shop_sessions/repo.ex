defmodule ShopSessions.Repo do
  use Ecto.Repo,
    otp_app: :shop_sessions,
    adapter: Ecto.Adapters.Postgres
end
