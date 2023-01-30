defmodule Discuss.TopicData do
  alias Discuss.Repo
  alias Discuss.Topic

  def get_topics() do
    Repo.all(Topic)
  end

  def get_topic(topic_id) do
    Repo.get(Topic, topic_id)
  end
  def get_topic!(topic_id) do
    Repo.get!(Topic, topic_id)
  end

  def add_topic(changeset) do
    Repo.insert(changeset)
  end
  
  def update_topic(changeset) do
    Repo.update(changeset)
  end
  
  def delete_topic!(changeset) do
    Repo.delete!(changeset)
  end

end