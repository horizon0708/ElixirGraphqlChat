defmodule GraphqlChat.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :name, :string
    field :role_id, :id
    field :avatar_url, :string
    field :github_id, :string
    field :token, :string, virtual: true
    has_many :messages, GraphqlChat.Messages.Message

    timestamps()
  end

  def data() do
    Dataloader.Ecto.new(GraphqlChat.Repo)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :role_id, :avatar_url, :github_id])
    |> foreign_key_constraint(:role_id)
    |> unique_constraint(:github_id)
    |> validate_required([:name])
  end
end
