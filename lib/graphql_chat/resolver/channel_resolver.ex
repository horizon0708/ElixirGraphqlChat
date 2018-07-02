defmodule GraphqlChat.ChannelResolver do
  alias GraphqlChat.Channels

  def all(_args, _info) do
    {:ok, Channels.list_channels()}
  end

  def find(%{id: id}, _info) do
    case Channels.get_channel!(id) do
      nil -> {:error, "Channel id #{id} not found"}
      channel -> {:ok, channel}
    end
  end

  def create(args, _info) do
    Channels.create_channel(args)
  end

  def update(%{id: id, channel: channel_params}, _info) do
    Channels.get_channel!(id)
    |> Channels.update_channel(channel_params)
  end

  def delete(%{id: id}, _info) do
    Channels.get_channel!(id)
    |> Channels.delete_channel
  end
end
