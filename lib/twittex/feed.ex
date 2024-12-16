defmodule Twittex.Feed do
  alias Twittex.Accounts.User
  alias Twittex.Feed.{Follow,Tweek}
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
    res = user
    |> Ecto.build_assoc(:tweeks)
    |> Tweek.changeset(attrs)
    |> Repo.insert

    if {:ok, tweek} = res, do: {:ok, Repo.preload(tweek, :user)}
  end

  def change_tweek(%Tweek{} = tweek, attrs \\ %{}) do
    Tweek.changeset(tweek, attrs)
  end

  def follows?(%User{id: follower_id}, %User{id: followed_id}) do
    follow_query(follower_id, followed_id)
    |> Repo.exists?
  end

  def follow!(follower_id, followed_id) do
    %Follow{}
    |> Follow.changeset(%{followed_id: followed_id, follower_id: follower_id})
    |> Repo.insert
  end

  def unfollow!(follower_id, followed_id) do
    follow_query(follower_id, followed_id)
    |> Repo.one!
    |> Repo.delete!
  end

  defp follow_query(follower_id, followed_id) do
    Follow
    |> where(
      [f],
      f.followed_id == ^followed_id and f.follower_id == ^follower_id
    )
  end

  def list_feed_for_user(%User{} = user) do
    from(
      t in Tweek,
      join: u in assoc(t, :user),
      join: f in assoc(u, :followers),
      where: f.id == ^user.id
    )
    |> order_by([m], [desc: m.inserted_at, desc: m.id])
    |> preload(:user)
    |> Repo.all
  end
end
