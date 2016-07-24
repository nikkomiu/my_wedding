# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# General application configuration
config :wedding_website,
  ecto_repos: [WeddingWebsite.Repo]

config :phoenix, :template_engines,
  haml: PhoenixHaml.Engine

config :phoenix_inline_svg, default_collection: "material"

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
