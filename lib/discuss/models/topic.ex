defmodule Discuss.Topic do
  use Discuss, :model
  alias Discuss.Identicon


  schema "topics" do
    field :title, :string
    field :body, :string
    field :identicon, :string
    belongs_to :user, Discuss.User
    has_many :comments, Discuss.Comment

    timestamps()

  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body])
    |> validate_required([:title, :body])
    |> validate_length(:body, min: 5, max: 1000)
  end

  def connect_topic_to_user(user) do
    build_assoc(user, :topics)
  end

  def add_identicon(changeset, %{"title" => title}) do
    identicon = Identicon.create_identicon(title)
    change(changeset, %{identicon: identicon})
  end
end