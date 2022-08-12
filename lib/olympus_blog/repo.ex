defmodule OlympusBlog.Repo do
  use Ecto.Repo,
    otp_app: :olympus_blog,
    adapter: Ecto.Adapters.Postgres
end
