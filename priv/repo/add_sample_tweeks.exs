alias Twittex.Repo
alias Twittex.Feed.Tweek
alias Twittex.Accounts

users = for name <- ~w(mark bill elon jeff) do
  {:ok, user} = Accounts.register_user(%{
    username: name,
    email: name <> "@example.com",
    password: "123Test123!!"
  })
  Accounts.save_user_avatar!(user, name <> ".png")
end

for _ <- 1..100 do
  Repo.insert!(%Tweek{
    content: Faker.StarWars.quote(),
    user_id: Enum.random(users).id,
    inserted_at: Faker.DateTime.backward(30) |> DateTime.truncate(:second)
  })
end
