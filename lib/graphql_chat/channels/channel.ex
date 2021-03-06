defmodule GraphqlChat.Channels.Channel do
  use Ecto.Schema
  import Ecto.Changeset


  schema "channels" do
    field :name, :string
    has_many :messages, GraphqlChat.Messages.Message
    has_many :users, GraphqlChat.Users.User

    timestamps()
  end

  def data() do
    Dataloader.Ecto.new(GraphqlChat.Repo)
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
