defmodule TwittexWeb.ProfileLive do
  use TwittexWeb, :live_view

  alias Twittex.Accounts

  def mount(%{"username" => username}, _session, socket) do
    user = Accounts.get_user_by_username!(username)
    {:ok, assign(socket, :user, user)}
  end
end
