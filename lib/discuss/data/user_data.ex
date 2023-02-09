defmodule Discuss.UserData do
  alias Discuss.{Repo, User}


  def get_user_by_email(user_email) do
    Repo.get_by(User, email: user_email)
  end

  def get_user_by_id(user_id) do
    Repo.get(User, user_id)
  end

  def add_user(changeset) do
    Repo.insert(changeset)
  end
end