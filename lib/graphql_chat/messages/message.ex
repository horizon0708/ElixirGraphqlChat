defmodule GraphqlChat.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset


  schema "messages" do
    field :edited, :boolean, default: false
    field :message, :string
    field :parent, :integer
    belongs_to :user, GraphqlChat.Users.User
    belongs_to :channel, GraphqlChat.Channels.Channel

    timestamps()
  end

  def data() do
    Dataloader.Ecto.new(GraphqlChat.Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  # def query()

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message, :edited, :parent, :user_id, :channel_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:channel_id)
    |> validate_required([:message])
  end
end
