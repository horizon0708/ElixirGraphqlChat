defmodule GraphqlChatWeb.Schema.UserTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: GraphqlChat.Repo
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :user do
    field :id, :id
    field :name, :string
    field :token, :string
    field :avatar_url, :string
    field :messages, list_of(:message), resolve: dataloader(:message)
  end

  object :user_queries do
    field :users, list_of(:user) do
      resolve &GraphqlChat.UserResolver.all/2
    end

    field :user, :user do
      arg :id, non_null(:id)
      resolve &GraphqlChat.UserResolver.find/2
    end

    field :user_token, :user do
      arg :token, non_null(:string)

      resolve &GraphqlChat.UserResolver.find_by_token/2
    end

    field :user_login, :user do
      arg :code, non_null(:string)
      resolve &GraphqlChat.UserResolver.login/2
    end
  end

  input_object :update_user_params do
    field :name, non_null(:string)
  end

  object :user_mutations do
    field :create_user, type: :user do
      arg :name, non_null(:string)

      resolve &GraphqlChat.UserResolver.create/2
    end

    field :update_user, type: :user do
      arg :id, non_null(:id)
      arg :user, :update_user_params

      resolve &GraphqlChat.UserResolver.update/2
    end

    field :delete_user, type: :user do
      arg :id, non_null(:id)

      resolve &GraphqlChat.UserResolver.delete/2
    end



    field :test_user_login, type: :user do
      arg :id, non_null(:id)

      resolve &GraphqlChat.UserResolver.login_test/2
    end
  end
end
