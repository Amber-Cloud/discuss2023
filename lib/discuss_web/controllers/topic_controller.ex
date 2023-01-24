defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic
  alias Discuss.TopicData
  def index(conn, _params \\ %{}) do
    render(conn, "index.html", topics: TopicData.get_topics())
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)
    case TopicData.add_topic(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Please submit a valid topic")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = TopicData.get_topic(topic_id)
    render(conn, "edit.html", changeset: Topic.changeset(topic), topic: topic)
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = TopicData.get_topic(topic_id)
    changeset = Topic.changeset(old_topic, topic)

    case TopicData.update_topic(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Please submit a valid topic")
        |> render("new.html", changeset: changeset, topic: old_topic)
    end
  end
  
  def delete(conn, %{"id" => topic_id}) do
    topic_id
    |> TopicData.get_topic!()
    |> Topic.changeset()
    |> TopicData.delete_topic!()

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
  end
end
