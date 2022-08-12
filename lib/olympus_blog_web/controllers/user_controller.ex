defmodule OlympusBlogWeb.UserController do
  use OlympusBlogWeb, :controller

  alias OlympusBlog.Account
  alias OlympusBlog.Account.User

  action_fallback OlympusBlogWeb.FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- Account.create_user(params) do
      conn
      |> put_session(:user_id, user.id)
      |> configure_session(renew: true)
      |> put_status(:created)
      |> render("user.json", user: user)
    end
  end

  def show(conn, _params) do
    user = Account.get_user!(get_session(conn, :user_id))
    render(conn, "user.json", user: user)
  end

  def update(conn, params) do
    user = Account.get_user!(get_session(conn, :user_id))

    with {:ok, %User{} = user} <- Account.update_user(user, params) do
      render(conn, "user.json", user: user)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case OlympusBlog.Account.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> put_status(:ok)
        |> put_view(OlympusBlogWeb.UserView)
        |> render("user.json", user: user)

      {:error, message} ->
        conn
        |> delete_session(:user_id)
        |> put_status(:unauthorized)
        |> put_view(OlympusBlogWeb.ErrorView)
        |> render("401.json", message: message)
    end
  end

  def logout(conn, _params) do
    configure_session(conn, drop: true)
    |> send_resp(200, "")
  end
end
