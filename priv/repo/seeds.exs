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

alias GraphqlChat.Users
alias GraphqlChat.Channels
alias GraphqlChat.Roles
alias GraphqlChat.Messages

Channels.create_channel(%{name: "General"})
Channels.create_channel(%{name: "Private"})
Roles.create_role(%{name: "Admin"})
Roles.create_role(%{name: "Member"})
Roles.create_role(%{name: "Non-member"})
Users.create_user(%{name: "John Doe", role_id: 1})
Users.create_user(%{name: "Some guy", role_id: 3})

for _ <- 1..15 do
  IO.inspect(
    Messages.create_message(%{
      user_id: [1, 2] |> Enum.take_random(1) |> hd,
      channel_id: [1, 2] |> Enum.take_random(1) |> hd,
      message: Faker.Lorem.sentence()
    })
  )
end
