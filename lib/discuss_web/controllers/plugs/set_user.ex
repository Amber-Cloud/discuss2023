defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn

  alias Discuss.UserData

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)
    # && evaluates first left hand, then if true - right hand
    # returns right hand value
    user = user_id && UserData.get_user_by_id(user_id)
    cond do
      user -> assign(conn, :user, user)
      true -> assign(conn, :user, %{id: nil})
    end
  end
end