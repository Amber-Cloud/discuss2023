defmodule DiscussWeb.UserChannelTest do
  use DiscussWeb.ChannelCase
  alias DiscussWeb.UserSocket
  alias Discuss.{Repo, User}

  test "connect fun adds verified user id to the socket" do
    {:ok, user} = %User{email: "hello@gmail.com"} |> Repo.insert()
    token = Phoenix.Token.sign(DiscussWeb.Endpoint, "key", user.id)

    assert {:ok, _socket} = connect(UserSocket, %{"token" => token})
    assert :error = connect(UserSocket, %{"token" => "invalid data"})
  end
end