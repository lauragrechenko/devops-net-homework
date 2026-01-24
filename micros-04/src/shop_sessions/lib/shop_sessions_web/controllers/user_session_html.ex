defmodule ShopSessionsWeb.UserSessionHTML do
  use ShopSessionsWeb, :html

  embed_templates "user_session_html/*"

  defp local_mail_adapter? do
    Application.get_env(:shop_sessions, ShopSessions.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
