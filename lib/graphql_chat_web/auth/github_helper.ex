defmodule GraphqlChatWeb.GitHubHelper do
  @moduledoc """
  An OAuth2 strategy for GitHub.
  """
  use OAuth2.Strategy
  alias OAuth2.Strategy.AuthCode

  defp config do
    [strategy: GraphqlChatWeb.GitHubHelper,
     site: "https://api.github.com",
     authorize_url: "https://github.com/login/oauth/authorize",
     token_url: "https://github.com/login/oauth/access_token"]
  end

  # Public API

  def client do
    Application.get_env(:graphql_chat, GraphqlChatWeb.GitHub)
    |> IO.inspect
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params) do
    IO.inspect(params)
    OAuth2.Client.get_token!(client(), Keyword.merge(params, client_secret: client().client_secret))
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end
