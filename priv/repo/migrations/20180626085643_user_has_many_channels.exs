defmodule GraphqlChat.Repo.Migrations.UserHasManyChannels do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :avatar_url, :string
      add :channel_id, references(:channels, on_delete: :nothing)
    end

    create index(:users, [:channel_id])
  end
end
