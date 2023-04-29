defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel
  alias Discuss.{TopicData, CommentData, Comment}

  @impl true
  def join("comments:" <> topic_id, _payload, socket) do
    topic =
      topic_id
      |> String.to_integer()
      |> TopicData.get_topic()
      |> CommentData.get_comments_for_topic()
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("comment:add", %{"content" => content}, socket) do
    changeset =
      socket.assigns.topic
      |> Comment.connect_comment_to_topic(socket.assigns.user_id)
      |> Comment.changeset(%{content: content})

    case CommentData.add_comment(changeset) do
      {:ok, comment} ->
        preloaded_comment = CommentData.get_comment_user(comment)
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: preloaded_comment})
        {:reply, :ok, socket}
      {:error, _reason} -> {:reply, {:error, %{errors: changeset}}, socket}

    end
  end
end
