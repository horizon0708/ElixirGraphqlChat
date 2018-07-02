defmodule GraphqlChat.UserResolver do
  alias GraphqlChat.{Users, Roles}
  alias GraphqlChat.Users.User
  alias GraphqlChatWeb.Authentication

  def all(_args, _info) do
    {:ok, Users.list_users()}
  end

  def find(%{id: id}, _info) do
    case Users.get_user!(id) do
      nil -> {:error, "User id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def create(args, _info) do
    Users.create_user(args)
  end

  def update(%{id: id, user: user_params}, _info) do
    Users.get_user!(id)
    |> Users.update_user(user_params)
  end

  def delete(%{id: id}, _info) do
    Users.get_user!(id)
    |> Users.delete_user()
  end

  def find_by_token(%{token: token},_info) do
    with {:ok, data} <- GraphqlChatWeb.Authentication.verify(token) do
      IO.inspect data
      find(%{id: data.id}, [])
    end
  end

  def login(%{code: code}, _info) do
    # use temp code to get userinfo from github API
    # if there is no github user/ then error out with no auth
    # if there is a valid github user, but no matching user, create user then give signed JWT token
    # if there is a valid github user and a matching user, give signed JWT token
    with {:ok, user} <- get_github_user(code) do
      IO.inspect(user)

      case Users.get_user_by_github_id(user.github_id) do
        {:ok, existing_user} ->
          IO.inspect(existing_user)
          {:ok,
           %{
             id: existing_user.id,
             name: existing_user.name,
             avatar_url: existing_user.avatar_url,
             token: Authentication.sign(%{id: existing_user.id})
           }}

        {:error} ->
          {:ok, new_user} =
            Users.create_user(%{
              name: user.name,
              avatar_url: user.avatar_url,
              github_id: user.github_id,
              role_id: Roles.get_role_by_name!("Member").id
            })

          {:ok,
           %{
             id: new_user.id,
             name: new_user.name,
             avatar_url: new_user.avatar_url,
             token: Authentication.sign(%{id: new_user.id})
           }}
      end
    end
  end

  def login_test(%{id: id}, _info) do
    {:ok, %{token: Authentication.sign(%{id: id})}}
  end

  defp get_github_user(code) do
    GraphqlChatWeb.GitHubHelper.get_token!(code: code)
    |> get_user
  end

  defp get_user(client) do
    case OAuth2.Client.get(client, "/user") do
      {:ok, %{body: user}} ->
        IO.inspect user
        {:ok, %{name: user["name"], avatar_url: user["avatar_url"], github_id: user["login"]}}
      {:error, _} -> {:error, "Invalid Github Login Code"}
    end
  end
end
