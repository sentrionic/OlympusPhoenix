# OlympusPhoenix (Unfinished)

OlympusPhoenix is a backend for the [OlympusBlog](https://github.com/sentrionic/OlympusBlog) using the [Phoenix Framework](https://www.phoenixframework.org/).

## Stack

- [Phoenix](https://www.phoenixframework.org/) as the server.
- [Ecto](https://github.com/elixir-ecto/ecto) as the ORM.

## Getting started

1. Install [Elixir](https://elixir-lang.org/) and Phoenix.
2. Clone this repository
3. Install Postgres and Redis.
4. Run `mix deps.get` to install all the dependencies
5. Rename `dev.secret.example.exs` to `dev.secret.exs` and fill in the values.
6. Run `mix phx.server` to run the server
7. Go to `localhost:4000` for a list of all the endpoints.

## Notes

- Image resizing requires [ImageMagick](https://imagemagick.org/) to be installed, so it's not build into this stack.
- `TODO.txt` contains the missing items.

## Credits

- [tamanugi](https://github.com/tamanugi/realworld-phoenix): Reference project
