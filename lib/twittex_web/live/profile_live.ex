defmodule TwittexWeb.ProfileLive do
  use TwittexWeb, :live_view

  alias Twittex.Accounts
  alias Twittex.Feed

  import TwittexWeb.AvatarHelper
  import TwittexWeb.FeedComponents

  on_mount({TwittexWeb.UserAuth,:mount_current_user})

  def mount(%{"username" => username}, _session, socket) do
    user = Accounts.get_user_by_username!(username)
    tweeks = Feed.list_tweeks_for_user(user)
    change_tweek = Feed.change_tweek(%Feed.Tweek{}) |> to_form()
    {:ok, assign(socket, form: change_tweek, tweeks: tweeks, user: user)}
  end

  def handle_event("save", %{"tweek" => tweek}, socket) do 
    user = socket.assigns.user
    case Feed.create_tweek_for_user(user, tweek) do
      {:ok, tweek} ->
        socket = update(socket, :tweeks, & [tweek | &1])
        new_tweek = %Feed.Tweek{} |> Feed.change_tweek() |> to_form()
        {:noreply, assign(socket, form: new_tweek)}
      {:error, changeset} ->
        {:noreply, changeset |> to_form()}
    end
  end
  
  def handle_event("validate", %{"tweek" => tweek}, socket) do
    change = %Feed.Tweek{} |> Feed.change_tweek(tweek) |> to_form(action: :validate)
    {:noreply, assign(socket, form: change)}
  end
end
