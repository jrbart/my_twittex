defmodule TwittexWeb.FeedLive do
  use TwittexWeb, :live_view

  alias Twittex.Feed

  on_mount {TwittexWeb.UserAuth, :mount_current_user}

  import TwittexWeb.FeedComponents

  def mount(_params, _session, socket) do
    tweeks = if socket.assigns.current_user do
      Feed.list_feed_for_user(socket.assigns.current_user)
    else
      []
    end

    {:ok, assign(socket, tweeks: tweeks)}
  end

  def render(assigns) do
    ~H"""
    <div class="mt-3">
      <%= if @current_user do %>
        <%= if Enum.empty?(@tweeks) do %>
          <div class="text-center py-10">
            <h2 class="text-gray-500 text-2xl">Nothing to see!</h2>
            <p class="text-gray-400">You're not following anyone yet.</p>
          </div>
        <% else %>
          <.tweek_in_feed :for={tweek <- @tweeks} tweek={tweek} />
        <% end %>
      <% else %>
        <p class="text-center text-gray-400">You're not logged in.</p>
      <% end %>
    </div>
    """
  end
end
