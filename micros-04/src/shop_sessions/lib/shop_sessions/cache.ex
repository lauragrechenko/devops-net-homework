defmodule ShopSessions.Cache do
  use Nebulex.Cache,
    otp_app: :shop_sessions,
    adapter: Nebulex.Adapters.Redis
end
