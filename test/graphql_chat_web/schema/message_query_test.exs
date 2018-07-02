defmodule GraphqlChatWeb.Schema.MessageQueryTest do
  use GraphqlChatWeb.ConnCase, async: true

  setup do
    GraphqlChat.Schema.Seeds.run()
  end

  @plain_query """
  {
    messages{
      message
   }
  }
  """

  @desc_query """
  {
    messages(order: DESC){
      message
   }
  }
  """

  test "message field with no args returns list of messages in asc order" do
    conn = build_conn()
    conn = get(conn, "/api", query: @plain_query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "messages" => [
                 %{"message" => "message_1"},
                 %{"message" => "message_2"},
                 %{"message" => "message_3"},
                 %{"message" => "message_4"},
                 %{"message" => "message_5"},
                 %{"message" => "message_6"},
                 %{"message" => "message_7"},
                 %{"message" => "message_8"},
                 %{"message" => "message_9"},
                 %{"message" => "message_10"}
               ]
             }
           }
  end

  test "message field returns list of messages in desc order" do
    conn = build_conn()
    conn = get(conn, "/api", query: @desc_query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "messages" => [
                 %{"message" => "message_10"},
                 %{"message" => "message_9"},
                 %{"message" => "message_8"},
                 %{"message" => "message_7"},
                 %{"message" => "message_6"},
                 %{"message" => "message_5"},
                 %{"message" => "message_4"},
                 %{"message" => "message_3"},
                 %{"message" => "message_2"},
                 %{"message" => "message_1"}
               ]
             }
           }
  end
end
