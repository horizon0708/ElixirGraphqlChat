defmodule GraphqlChatWeb.SubscriptionCase do
  @moduledoc """
  This module defines the test case to be used by
  subscription tests
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      use GraphqlChatWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest, schema: GraphqlChatWeb.Schema

      setup do
        GraphqlChat.Schema.Seeds.run()
        {:ok, socket} = Phoenix.ChannelTest.connect(GraphqlChatWeb.UserSocket, %{})
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)
        {:ok, socket: socket}
      end

      import unquote(__MODULE__), only: [user: 1, channel: 1]
    end
  end

  # handy function for grabbing a fixture
  def user(name) do
    GraphqlChat.Repo.get_by!(GraphqlChat.Users.User, name: name)
  end

  def channel(name) do
    GraphqlChat.Repo.get_by!(GraphqlChat.Channels.Channel, name: name)
  end
end
