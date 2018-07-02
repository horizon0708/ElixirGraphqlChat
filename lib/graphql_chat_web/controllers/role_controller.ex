defmodule GraphqlChatWeb.RoleController do
  use GraphqlChatWeb, :controller

  alias GraphqlChat.Roles
  alias GraphqlChat.Roles.Role

  action_fallback GraphqlChatWeb.FallbackController

  def index(conn, _params) do
    roles = Roles.list_roles()
    render(conn, "index.json", roles: roles)
  end


  def show(conn, %{"id" => id}) do
    role = Roles.get_role!(id)
    render(conn, "show.json", role: role)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = Roles.get_role!(id)

    with {:ok, %Role{} = role} <- Roles.update_role(role, role_params) do
      render(conn, "show.json", role: role)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Roles.get_role!(id)
    with {:ok, %Role{}} <- Roles.delete_role(role) do
      send_resp(conn, :no_content, "")
    end
  end
end
