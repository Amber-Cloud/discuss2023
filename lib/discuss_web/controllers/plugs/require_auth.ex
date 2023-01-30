defmodule DiscussWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller
  alias DiscussWeb.Router.Helpers , as: Routes
  alias Discuss.UserData

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end
