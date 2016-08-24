# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# General application configuration
config :my_wedding,
  ecto_repos: [MyWedding.Repo],
  recaptcha_key: "6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI",
  recaptcha_secret: "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe"

config :phoenix, :template_engines,
  haml: PhoenixHaml.Engine

# Set Material Icons as Inline SVG default collection
config :phoenix_inline_svg, default_collection: "material"

# Configures Ueberauth OAuth Providers
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

# Configures Ueberauth OAuth Google Strategy
config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "63977908379-66go2n9q1mqofm0fmljl0kh8jg0h3ikm.apps.googleusercontent.com",
  client_secret: "PCR4EqilrjdbsJjtZwosSywa"

# Configures Guardian
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "MyWedding",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: "cQaNG1xMqLKv6RcXTRFQjutCb1dHoozgHeW1sDkE1lFJqWHNgad1CKpZNP5Xq5dn",
  serializer: MyWedding.GuardianSerializer

# Configures the endpoint
config :my_wedding, MyWedding.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cQaNG1xMqLKv6RcXTRFQjutCb1dHoozgHeW1sDkE1lFJqWHNgad1CKpZNP5Xq5dn",
  render_errors: [view: MyWedding.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MyWedding.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config.
import_config "#{Mix.env}.exs"
