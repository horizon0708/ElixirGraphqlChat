defmodule GraphqlChatWeb.Middleware.Authorize do
  alias GraphqlChat.Roles
  @behaviour Absinthe.Middleware

  def call(resolution, roles) do
    with %{current_user: current_user} <- resolution.context,
         %{id: role_id} <- current_user,
         true <- correct_role?(Roles.get_role!(role_id), roles) do
      resolution
    else
      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "Unauthorized"})
    end
  end

  defp correct_role?(%{}, :any), do: true

  defp correct_role?(%{name: role}, roles) do
    Enum.member?(roles, role)
  end

  defp correct_role?(_, _), do: false
end
