defmodule TwittexWeb.AvatarUploadLive do
  use TwittexWeb, :live_view

  alias Twittex.Accounts
  alias Twittex.Feed

  on_mount({TwittexWeb.UserAuth,:mount_current_user})

  @msize 2*1024*1024
  @ftype ~w(.jpg .jpeg .png)

  def mount(_params, _session, socket) do
    {:ok, 
    socket
    |> assign(:avatar_image, [])
    |> allow_upload(:avatar, accept: @ftype, max_file_size: @msize, max_entries: 1)
    }
    
  end
  
  def handle_event("validate", _unsigned_params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", _unsigned_params, socket) do
    [avatar] =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:twittex), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    Accounts.save_user_avatar!(socket.assigns.current_user, Path.basename(avatar))
    {:noreply, socket}
  end
end
