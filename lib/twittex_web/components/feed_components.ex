defmodule TwittexWeb.FeedComponents do
  use TwittexWeb, :html

  alias Twittex.Feed.Tweek

  attr :tweek, Tweek
  def tweek_in_feed(assigns) do
    ~H"""
    <div class="bg-white p-5 rounded-lg shadow mb-3">
      <div class="flex justify-between items-center">
        <div class="flex items-center">
          <img src={~p"/images/default_avatar.png"} class="h-12 w-12 rounded" alt="Avatar" />
          <div class="ml-3">
            <h2 class="font-bold text-lg">@<%= @tweek.user.username %></h2>
            <p class="text-gray-400 ml-2"><%= Timex.from_now(@tweek.inserted_at) %></p>
          </div>
        </div>
      </div>
      <p class="mt-3 text-gray-700">
        <%= @tweek.content %>
      </p>
    </div>
    """
  end
end
