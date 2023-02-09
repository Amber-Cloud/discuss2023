defmodule Discuss.CommentData do
  alias Discuss.Repo

  def add_comment(changeset) do
    Repo.insert(changeset)
  end

  def get_comments_for_topic(topic) do
    Repo.preload(topic, comments: [:user])
  end

  def get_comment_user(comment) do
    Repo.preload(comment, [:user])
  end

  def update_comment(changeset) do
    Repo.update(changeset)
  end
  
  def delete_comment!(changeset) do
    Repo.delete!(changeset)
  end

end