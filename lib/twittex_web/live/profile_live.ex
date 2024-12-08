defmodule TwittexWeb.ProfileLive do
  use TwittexWeb, :live_view

  alias Twittex.Accounts
  alias Twittex.Feed

  import TwittexWeb.FeedComponents

  on_mount({TwittexWeb.UserAuth,:mount_current_user})

  def mount(%{"username" => username}, _session, socket) do
    user = Accounts.get_user_by_username!(username)
    tweeks = Feed.list_tweeks_for_user(user)
    change_tweek = Feed.change_tweek(%Feed.Tweek{}) |> to_form()
    {:ok, assign(socket, form: change_tweek, tweeks: tweeks, user: user)}
  end
end
