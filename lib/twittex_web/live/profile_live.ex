defmodule TwittexWeb.ProfileLive do
  use TwittexWeb, :live_view

  alias Twittex.Accounts
  alias Twittex.Feed

  import TwittexWeb.FeedComponents

  def mount(%{"username" => username}, _session, socket) do
    user = Accounts.get_user_by_username!(username)
    tweeks = Feed.list_tweeks_for_user(user)
    {:ok, assign(socket, tweeks: tweeks, user: user)}
  end
end
