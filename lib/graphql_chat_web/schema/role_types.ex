defmodule GraphqlChatWeb.Schema.RoleTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: GraphqlChat.Repo
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :role do
    field :id, :id
    field :name, :string
    field :users, list_of(:user), resolve: dataloader(:user)
  end

  object :role_queries do
    field :roles, list_of(:role) do
      resolve &GraphqlChat.RoleResolver.all/2
    end

    field :role, :role do
      arg :id, :id
      resolve &GraphqlChat.RoleResolver.find/2
    end
  end

  input_object :update_role_params do
    field :name, non_null(:string)
  end

  object :role_mutations do
    field :create_role, type: :role do
      arg :name, non_null(:string)

      resolve &GraphqlChat.RoleResolver.create/2
    end

    field :update_role, type: :role do
      arg :id, non_null(:id)
      arg :role, :update_role_params

      resolve &GraphqlChat.RoleResolver.update/2
    end

    field :delete_role, type: :role do
      arg :id, non_null(:id)

      resolve &GraphqlChat.RoleResolver.delete/2
    end
  end
end
