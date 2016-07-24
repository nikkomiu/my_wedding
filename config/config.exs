# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# General application configuration
config :wedding_website,
  ecto_repos: [WeddingWebsite.Repo]

config :phoenix, :template_engines,
  haml: PhoenixHaml.Engine

# Set Material Icons as Inline SVG default collection
config :phoenix_inline_svg, default_collection: "material"

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "63977908379-uh874dturf2bsmcbtcgjf5joc10m950b.apps.googleusercontent.com",
  client_secret: "oAyukfYtNEERpMnJNHCIf9Dg"
#  client_id: "${GOOGLE_CLIENT_ID}",
#  client_secret: "${GOOGLE_CLIENT_SECRET}"

# Configures the endpoint
config :wedding_website, WeddingWebsite.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cQaNG1xMqLKv6RcXTRFQjutCb1dHoozgHeW1sDkE1lFJqWHNgad1CKpZNP5Xq5dn",
  render_errors: [view: WeddingWebsite.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WeddingWebsite.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config.
import_config "#{Mix.env}.exs"
