defmodule Discuss.Topic do
  use Discuss, :model

  schema "topics" do
    field :title, :string
    belongs_to :user, Discuss.User
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end


  def connect_topic_to_user(user) do
    build_assoc(user, :topics)
  end
end