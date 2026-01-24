defmodule ShopSessionsWeb.PageController do
  use ShopSessionsWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
