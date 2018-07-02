defmodule GraphqlChatWeb.Schema.MessageTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: GraphqlChat.Repo
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :message do
    field :id, :id
    field :user, :user, resolve: dataloader(:user)
    field :channel, :channel, resolve: dataloader(:channel)
    field :message, :string
    field :parent, :integer
    field :edited, :boolean
    field :inserted_at, :string
  end

  enum :sort_order do
    value :asc
    value :desc
  end

  object :message_list do
    field :messages, list_of(:message)
    field :cursor, :string
  end

  object :message_queries do
    field :messages, list_of(:message) do
      # arg :filter, :string
      arg :order, :sort_order, default_value: :asc

      # middleware GraphqlChatWeb.Middleware.Authorize, ["Admin", "Member"]
      resolve &GraphqlChat.MessageResolver.all/2
    end

    field :message, :message do
      arg :id, non_null(:id)
      resolve &GraphqlChat.MessageResolver.find/2
    end

    field :list_messages, :message_list do
      arg :channel_id, non_null(:id)
      arg :cursor, :string

      resolve &GraphqlChat.MessageResolver.latest/2
    end
  end

  input_object :update_message_params do
    field :message, non_null(:string)
    field :channel_id, non_null(:id)
    field :user_id, non_null(:id)
  end

  @desc "Filtering options for messages"
  input_object :messages_filter do
    @desc "Message search"
    field :search, :string
  end

  object :message_subscriptions do
    field :new_message, :message do
      arg :channel_id, non_null(:id)

      config fn args, _info ->
        {:ok, topic: args.channel_id}
      end

      trigger :create_message, topic: fn
        %{channel_id: id} -> [id]
        _ -> []
      end

      resolve fn message, _,_ ->
        {:ok, message}
      end
    end

    field :update_message, :message do
      arg :channel_id, non_null(:id)

      config fn args, _info ->
        {:ok, topic: args.channel_id}
      end

      trigger :update_message, topic: fn
        %{channel_id: id} -> [id]
        _ -> []
      end

      resolve fn message, _,_ ->
        {:ok, message}
      end
    end

    field :more_message, :message_list do
      arg :channel_id, non_null(:id)

      config fn args, _info ->
        {:ok, topic: args.channel_id}
      end

      trigger :list_messages, topic: fn
        %{channel_id: id} -> [id]
        _ -> []
      end

      resolve fn message, _,_ ->
        {:ok, message}
      end
    end
  end

  object :message_mutations do
    field :create_message, type: :message do
      arg :message, non_null(:string)
      arg :channel_id, non_null(:id)
      arg :user_id, non_null(:id)

      resolve &GraphqlChat.MessageResolver.create/2
    end

    field :update_message, type: :message do
      arg :id, non_null(:id)
      arg :message, non_null(:string)

      resolve &GraphqlChat.MessageResolver.update/2
    end

    field :delete_message, type: :message do
      arg :id, non_null(:id)

      resolve &GraphqlChat.MessageResolver.delete/2
    end
  end
end
