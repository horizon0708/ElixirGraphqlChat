defmodule GraphqlChatWeb.Schema.ChannelTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: GraphqlChat.Repo
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :channel do
    field :id, :id
    field :name, :string
    field :messages, list_of(:message) do
    #  middleware GraphqlChatWeb.Middleware.Authorize, ["Admin", "Member"]
     resolve dataloader(:message)
    end
  end

  object :channel_queries do
    field :channels, list_of(:channel) do
      # middleware GraphqlChatWeb.Middleware.Authorize, ["Admin", "Member"]
      resolve &GraphqlChat.ChannelResolver.all/2
    end

    field :channel, :channel do
      arg :id, non_null(:id)

      resolve &GraphqlChat.ChannelResolver.find/2
    end
  end

  input_object :update_channel_params do
    field :name, non_null(:string)
  end

  object :channel_mutations do
    field :create_channel, type: :channel do
      arg :name, non_null(:string)

      resolve &GraphqlChat.ChannelResolver.create/2
    end

    field :update_channel, type: :channel do
      arg :id, non_null(:integer)
      arg :channel, :update_channel_params

      resolve &GraphqlChat.ChannelResolver.update/2
    end

    field :delete_channel, type: :channel do
      arg :id, non_null(:integer)

      resolve &GraphqlChat.ChannelResolver.delete/2
    end
  end
end
