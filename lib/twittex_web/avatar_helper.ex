defmodule TwittexWeb.AvatarHelper do
  use TwittexWeb, :verified_routes

  alias Twittex.Accounts.User

  def avatar_path(%User{} = user) do
    if is_nil(user.avatar) do
      ~p"/images/default_avatar.png"
    else
      ~p"/uploads/#{user.avatar}"
    end
  end
end
