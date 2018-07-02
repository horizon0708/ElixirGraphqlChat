defmodule GraphqlChat.Roles.Role do
  use Ecto.Schema
  import Ecto.Changeset


  schema "roles" do
    field :name, :string
    has_many :users, GraphqlChat.Users.User

    timestamps()
  end

  def data() do
    Dataloader.Ecto.new(GraphqlChat.Repo)
  end


  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
