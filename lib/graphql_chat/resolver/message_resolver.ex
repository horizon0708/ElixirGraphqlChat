defmodule GraphqlChat.MessageResolver do
  alias GraphqlChat.Messages

  def all(args, _info) do
    {:ok, Messages.list_messages(args)}
  end

  def find(%{id: id}, _info) do
    case Messages.get_message!(id) do
      nil -> {:error, "Message id #{id} not found"}
      message -> {:ok, message}
    end
  end

  def latest(args, _) do
    Messages.list_messages_from(args)
  end

  def create(args, _info) do
    case Messages.create_message(args) do
      {:ok, message} ->
        # Absinthe.Subscription.publish(GraphqlChatWeb.Endpoint, message, new_message: message.channel_id)
        {:ok, message}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def update(%{id: id, message: message}, _info) do
    Messages.get_message!(id)
    |> Messages.update_message(%{message: message})
  end

  def delete(%{id: id}, _info) do
    Messages.get_message!(id)
    |> Messages.delete_message
  end
end
