defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic
  alias Discuss.TopicData

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_exists when action in [:show, :edit, :update, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]


  def index(conn, _params \\ %{}) do
    render(conn, "index.html", topics: TopicData.get_topics())
  end

  def show(conn, %{"id" => topic_id}) do
    topic = TopicData.get_topic(topic_id)
    identicon = "/images/" <> (topic.identicon |> Path.basename() || "no-file.png")
    render(conn, "show.html", topic: topic, identicon: identicon)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    # topic belongs to a user. Associating with the user before creating changeset
    changeset =
      conn.assigns.user
      |> Topic.connect_topic_to_user()
      |> Topic.changeset(topic)
      |> Topic.add_identicon(topic)
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
    changeset =
      Topic.changeset(old_topic, topic)
      |> Topic.add_identicon(topic)
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
  
  defp check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn
    if conn.assigns.user.id == TopicData.get_topic!(topic_id).user_id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit or delete this topic")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end

  defp check_topic_exists(conn, _params) do
    %{params: %{"id" => topic_id}} = conn
    if TopicData.get_topic(topic_id) do
      conn
    else
      conn
      |> put_flash(:error, "This topic doesn't exist")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end
