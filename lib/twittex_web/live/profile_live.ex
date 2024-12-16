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
    followed? =
      socket.assigns.current_user &&
        Feed.follows?(socket.assigns.current_user, user)

    {:ok, assign(socket, form: change_tweek, tweeks: tweeks, followed?: followed?, user: user)}
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

  
  def handle_event("follow", %{"user-id" => user_id}, socket) do
    Feed.follow!(socket.assigns.current_user.id, user_id)
    {:noreply, assign(socket, :followed?, true)}
  end

  def handle_event("unfollow", %{"user-id" => user_id}, socket) do
    Feed.unfollow!(socket.assigns.current_user.id, user_id)
    {:noreply, assign(socket, :followed?, false)}
  end

  attr :followed?, :boolean
  attr :user_id, :integer
  def follow_button(assigns) do
    ~H"""
    <button
      class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded"
      phx-click={if @followed?, do: "unfollow", else: "follow"}
      phx-value-user-id={@user_id}
    >
      <%= if @followed?, do: "Unfollow", else: "Follow" %>
    </button>
    """
  end
end
