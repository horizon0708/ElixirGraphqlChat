defmodule GraphqlChat.RoleResolver do
  alias GraphqlChat.Roles

  def all(_args, _info) do
    {:ok, Roles.list_roles()}
  end

  def find(%{id: id}, _info) do
    case Roles.get_role!(id) do
      nil -> {:error, "Role id #{id} not found"}
      role -> {:ok, role}
    end
  end

  def create(args, _info) do
    Roles.create_role(args)
  end

  def update(%{id: id, role: role_params}, _info) do
    Roles.get_role!(id)
    |> Roles.update_role(role_params)
  end

  def delete(%{id: id}, _info) do
    Roles.get_role!(id)
    |> Roles.delete_role
  end
end
