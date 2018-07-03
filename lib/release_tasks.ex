# http://blog.firstiwaslike.com/elixir-deployments-with-distillery-running-ecto-migrations/

defmodule Release.Tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:graphql_chat)

    path = Application.app_dir(:graphql_chat, "priv/repo/migrations")

    Ecto.Migrator.run(GraphqlChat.Repo, path, :up, all: true)
  end
end
