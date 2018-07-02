defmodule GraphqlChatWeb.Subscription.MutateMessageTest do
  use GraphqlChatWeb.SubscriptionCase

  @subscription_update """
  subscription($channelId: ID!){
    updateMessage(channelId: $channelId) {
      message
    }
  }
  """
  @subscription_new """
  subscription($channelId: ID!){
    newMessage(channelId: $channelId) {
      message
    }
  }
  """

  @mutation_create """
  mutation($userId: ID!, $channelId: ID!) {
   createMessage(message: "created", channelId: $channelId, userId: $userId) {
     message
     id
   }
  }
  """
  @mutation_update """
  mutation($messageId: ID!) {
   updateMessage(message: "edited", id: $messageId) {
     message
   }
  }
  """
  test "subscribe to order mutation updates", %{socket: socket} do
    ref = push_doc(socket, @subscription_new, variables: %{"channelId" => channel("General").id})
    assert_reply(ref, :ok, %{subscriptionId: subscription_ref1})

    ref =
      push_doc(
        socket,
        @mutation_create,
        variables: %{"userId" => user("John Doe").id, "channelId" => channel("General").id}
      )

    assert_reply(ref, :ok, reply)
    assert %{data: %{"createMessage" => %{"message" => _, "id" => message_id}}} = reply

    expected = %{
      result: %{data: %{"newMessage" => %{"message" => "created"}}},
      subscriptionId: subscription_ref1
    }

    assert_push "subscription:data", push
    assert expected == push

    #now test the mutations
    ref = push_doc(socket, @subscription_update, variables: %{"channelId" => channel("General").id})
    assert_reply(ref, :ok, %{subscriptionId: subscription_ref2})

    ref =
      push_doc(
        socket,
        @mutation_update,
        variables: %{"messageId" => message_id}
      )

    assert_reply(ref, :ok, reply)
    assert %{data: %{"updateMessage" => %{"message" => _}}} = reply

    expected = %{
      result: %{data: %{"updateMessage" => %{"message" => "edited"}}},
      subscriptionId: subscription_ref2
    }

    assert_push "subscription:data", push
    assert expected == push
  end
end
