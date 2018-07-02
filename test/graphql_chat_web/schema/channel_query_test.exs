defmodule GraphqlChatWeb.Schema.ChannelQueryTest do
  use GraphqlChatWeb.ConnCase, async: true

  setup do
    GraphqlChat.Schema.Seeds.run()
  end

  @query"""
  {
    channels{
      name
    }
  }
  """

  test "channels field returns list of channels" do
    conn = build_conn()
    conn = get conn, "/api", query: @query
    IO.inspect json_response(conn, 200)
    assert json_response(conn, 200) == %{
      "data" => %{
        "channels" => [
          %{"name" => "General"},
          %{"name" => "Private"}
        ]
      }
    }
  end

end
