# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :graphql_chat,
  ecto_repos: [GraphqlChat.Repo]

# Configures the endpoint
config :graphql_chat, GraphqlChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tSphd3ilWjexpr1CUAyFPnr9b4U6ngT4ODuMs6+F0NVqTbNusOok/MevuxRM+51z",
  render_errors: [view: GraphqlChatWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: GraphqlChat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
