defmodule Twittex.Feed do
  alias Twittex.Accounts.User
  alias Twittex.Feed.Tweek
  alias Twittex.Repo

  import Ecto.Query

  def list_tweeks_for_user(%User{} = user) do
    user
    |> Ecto.assoc(:tweeks)
    |> preload(:user)
    |> order_by([m], [desc: m.inserted_at, desc: m.id])
    |> Repo.all
  end

  def create_tweek_for_user(%User{} = user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:tweeks)
    |> Tweek.changeset(attrs)
    |> Repo.insert
  end
end
