defmodule Discuss.Comment do
  use Discuss, :model
  @derive {Jason.Encoder, only: [:content, :user, :inserted_at]}

  schema "comments" do
    field :content, :string
    belongs_to :user, Discuss.User
    belongs_to :topic, Discuss.Topic

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content])
    |> validate_required([:content])
    |> validate_length(:content, min: 2, max: 1000)
  end

  def connect_comment_to_topic(topic, user_id) do
    build_assoc(topic, :comments, user_id: user_id)
  end


end