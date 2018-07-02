defmodule GraphqlChatWeb.TokenSignTest do
  alias GraphqlChatWeb.Authentication
  use GraphqlChatWeb.ConnCase, async: true

  @data %{id: 333}
  @badtoken "EIEFJE*#$fwfiawf328aefjasdfl"

  test "Signed token can be verified" do
    {:ok, %{id: id}} =  Authentication.sign(@data)
    |> Authentication.verify
    assert id == 333
  end

  test "Bad token verification outputs an error" do
    assert {:error, :invalid} == Authentication.verify(@badtoken)
  end
end
