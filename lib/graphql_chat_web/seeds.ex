# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GraphqlChat.Repo.insert!(%GraphqlChat.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule GraphqlChat.Schema.Seeds do
  alias GraphqlChat.Users
  alias GraphqlChat.Users.User
  alias GraphqlChat.Channels
  alias GraphqlChat.Roles
  alias GraphqlChat.Roles.Role
  alias GraphqlChat.Messages

  def run do
    {:ok, %{id: general_id}} =  Channels.create_channel(%{name: "General"})
    {:ok, %{id: private_id}} = Channels.create_channel(%{name: "Private"})
    {:ok, %Role{id: admin_id}} = Roles.create_role(%{name: "Admin"})
    Roles.create_role(%{name: "Member"})
    {:ok, %Role{id: non_member_id}} = Roles.create_role(%{name: "Non-member"})
    {:ok, %User{id: user1_id}} =  Users.create_user(%{name: "John Doe", role_id: admin_id})
    {:ok, %User{id: user2_id}} = Users.create_user(%{name: "Some guy", role_id: non_member_id})

    # for _ <- 1..5 do
    #     Messages.create_message(%{
    #       user_id: [1, 2] |> Enum.take_random(1) |> hd,
    #       channel_id: [1, 2] |> Enum.take_random(1) |> hd,
    #       message: Faker.Lorem.sentence()
    #     })
    # end
    for n <- 1..10 do
      cond do
        (n < 6) -> Messages.create_message(%{
          user_id: user1_id,
          channel_id: general_id,
          message: "message_#{n}"
        })
        true ->  Messages.create_message(%{
          user_id: user2_id,
          channel_id: private_id,
          message: "message_#{n}"
        })
    end
  end

     :ok
  end
end
