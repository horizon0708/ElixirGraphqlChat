defmodule GraphqlChatWeb.Router do
  use GraphqlChatWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug GraphqlChatWeb.Context
  end

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug,
    schema: GraphqlChatWeb.Schema

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: GraphqlChatWeb.Schema,
    socket: PlateSlateWeb.UserSocket
  end


end
