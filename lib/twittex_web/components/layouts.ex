defmodule TwittexWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use TwittexWeb, :controller` and
  `use TwittexWeb, :live_view`.
  """
  use TwittexWeb, :html

  embed_templates "layouts/*"

  
  attr :href, :string, required: true
  attr :text, :string, required: true
  attr :method, :string, default: "get"
  def navbar_link(assigns) do
    ~H"""
    <.link
      class="mb-2 sm:mb-0 sm:mr-5 text-gray-700 hover:text-gray-500"
      href={@href}
      method={@method}
    >
      <%= @text %>
    </.link>
    """
  end
end
