use Mix.Config

config :my_wedding, MyWedding.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "wedding.nikkomiu.com", port: 443],
  cache_static_manifest: "priv/static/manifest.json"

config :my_wedding,
  environment: :prod,
  recaptcha_key: "${RECAPTCHA_KEY}",
  recaptcha_secret: "${RECAPTCHA_SECRET}"

# Logging
config :logger, level: :info

# Releases
config :phoenix, :serve_endpoints, true
config :my_wedding, MyWedding.Endpoint, root: "."

# Secret Key Base
config :my_wedding, MyWedding.Endpoint,
  secret_key_base: "${SECRET_KEY_BASE}"

# Configures Ueberauth OAuth Google Strategy
config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "${GOOGLE_CLIENT_ID}",
  client_secret: "${GOOGLE_CLIENT_SECRET}"

# Database
config :my_wedding, MyWedding.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "${DB_BASE}",
  username: "my_wedding_svc",
  password: "${DB_PASS}",
  hostname: "${DB_HOST}",
  port: "${DB_PORT}",
  pool_size: 20
