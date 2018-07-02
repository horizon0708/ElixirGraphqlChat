defmodule GraphqlChatWeb.Subscription.CreateMessageTest do
  use GraphqlChatWeb.SubscriptionCase

  @subscription """
  subscription($channelId: ID!){
    newMessage(channelId: $channelId) {
      message
    }
  }
  """
  @mutation """
  mutation($userId: ID!, $channelId: ID!) {
   createMessage(message: "hi", channelId: $channelId, userId: $userId) {
     message
   }
  }
  """
  test "subscribe to order updates", %{socket: socket} do
    ref = push_doc(socket, @subscription, variables: %{"channelId" => channel("General").id})
    assert_reply(ref, :ok, %{subscriptionId: subscription_id})

    ref =
      push_doc(
        socket,
        @mutation,
        variables: %{"userId" => user("John Doe").id, "channelId" => channel("General").id}
      )

    assert_reply(ref, :ok, reply)
    assert %{data: %{"createMessage" => %{"message" => _}}} = reply

    expected = %{
      result: %{data: %{"newMessage" => %{"message" => "hi"}}},
      subscriptionId: subscription_id
    }

    assert_push "subscription:data", push
    assert expected == push
  end
end
