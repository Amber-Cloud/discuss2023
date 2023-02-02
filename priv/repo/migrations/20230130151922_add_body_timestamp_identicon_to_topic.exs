defmodule Discuss.Repo.Migrations.AddBody do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      add :body, :string
      add :identicon, :string
      timestamps()
    end
  end
end
