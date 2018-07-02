defmodule GraphqlChatWeb.Schema do
  use Absinthe.Schema
  alias GraphqlChat.{Roles.Role, Users.User, Messages.Message, Channels.Channel}

  import_types(GraphqlChatWeb.Schema.{ChannelTypes, UserTypes, RoleTypes, MessageTypes})

  query do
    import_fields(:channel_queries)
    import_fields(:user_queries)
    import_fields(:role_queries)
    import_fields(:message_queries)
  end

  mutation do
    import_fields(:channel_mutations)
    import_fields(:user_mutations)
    import_fields(:role_mutations)
    import_fields(:message_mutations)
  end

  subscription do
    import_fields(:message_subscriptions)
  end


  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(:role, Role.data())
      |> Dataloader.add_source(:user, User.data())
      |> Dataloader.add_source(:message, Message.data())
      |> Dataloader.add_source(:channel, Channel.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
