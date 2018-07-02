defmodule GraphqlChatWeb.Authentication do
  @salt "somesaltthatshouldbeintheenv"

  def sign(data) do
    Phoenix.Token.sign(GraphqlChatWeb.Endpoint, @salt, data)
  end

  def verify(token) do
    Phoenix.Token.verify(GraphqlChatWeb.Endpoint, @salt, token, [
      max_age: 30 * 24 * 3600
    ])
  end
end
