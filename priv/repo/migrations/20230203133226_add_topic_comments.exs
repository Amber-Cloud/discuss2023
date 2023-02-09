defmodule Discuss.Repo.Migrations.AddTopicComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text
      add :user_id, references(:users)
      add :topic_id, references(:topics)

      timestamps()
    end
    alter table(:topics) do
      modify :body, :text
    end
  end
end
