defmodule TwittexWeb.UserSessionController do
  use TwittexWeb, :controller

  alias Twittex.Accounts
  alias TwittexWeb.UserAuth

  def new(conn, _params) do
    render(conn, :new, error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"username_or_email" => username_or_email, "password" => password} = user_params

    if user = Accounts.get_user_by_login_information(username_or_email, password) do
      conn
      |> put_flash(:info, "Welcome back!")
      |> UserAuth.log_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, :new, error_message: "Invalid login information")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
