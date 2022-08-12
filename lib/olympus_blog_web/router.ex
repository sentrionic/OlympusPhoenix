defmodule OlympusBlogWeb.Router do
  use OlympusBlogWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :api_auth do
    plug :ensure_authenticated
  end

  # AuthGuard
  scope "/api", OlympusBlogWeb do
    pipe_through [:api, :api_auth]

    get "/user", UserController, :show
    put "/user", UserController, :update

    post "/articles", ArticleController, :create
    get "/articles/feed", ArticleController, :feed

    put "/articles/:slug", ArticleController, :update
    delete "/articles/:slug", ArticleController, :delete

    post "/articles/:slug/comments", CommentController, :create
    delete "/articles/:slug/comments/:id", CommentController, :delete

    post "/profiles/:username/follow", ProfileController, :follow
    delete "/profiles/:username/follow", ProfileController, :unfollow

    post "/articles/:slug/favorite", FavoriteController, :create
    delete "/articles/:slug/favorite", FavoriteController, :delete

    post "/articles/:slug/bookmark", BookmarkController, :create
    delete "/articles/:slug/bookmark", BookmarkController, :delete
  end

  scope "/api", OlympusBlogWeb do
    pipe_through :api

    post "/users/login", UserController, :login
    post "/users/logout", UserController, :logout
    post "/users", UserController, :create

    get "/articles", ArticleController, :index
    get "/articles/tags", TagController, :index
    get "/articles/:slug", ArticleController, :show
    get "/articles/:slug/comments", CommentController, :list

    get "/profiles", ProfileController, :index
    get "/profiles/:username", ProfileController, :show
  end

  defp ensure_authenticated(conn, _opts) do
    user_id = get_session(conn, :user_id)

    if user_id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(OlympusBlogWeb.ErrorView)
      |> render("401.json", message: "Unauthenticated user")
      |> halt()
    end
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
            otp_app: :olympus_blog,
            swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      schemes: ["http", "https", "ws", "wss"],
      info: %{
        version: "1.0",
        title: "OlympusBlog",
        description: "API Documentation for OlympusBlog v1",
        termsOfService: "Open for public"
      },
      securityDefinitions: %{
        Bearer: %{
          type: "Cookie",
          name: "Authorization",
          description:
            "API Token must be provided via `Authorization: Bearer ` header",
          in: "header"
        }
      },
      consumes: ["application/json"],
      produces: ["application/json"],
    }
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: OlympusBlogWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
