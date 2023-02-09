defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller

  alias Discuss.{User, UserData}

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: Atom.to_string(auth.provider)}
    changeset = User.changeset(%User{}, user_params)
    sign_in(conn, changeset)
  end
  #handle the case where conn has no assigns
  def callback(conn, _params) do
    redirect(conn, to: Routes.topic_path(conn, :index))
  end

  def sign_out(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  defp sign_in(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case UserData.get_user_by_email(changeset.changes.email) do
      nil -> UserData.add_user(changeset)
      user -> {:ok, user}
    end
  end
end