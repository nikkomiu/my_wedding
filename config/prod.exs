use Mix.Config

config :my_wedding, MyWedding.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "wedding.nikkomiu.com", port: 80],
  cache_static_manifest: "priv/static/manifest.json"

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

config :my_wedding, MyWedding.Endpoint,
  force_ssl: [hsts: true]

# Database
config :my_wedding, MyWedding.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "my_wedding_prod",
  username: "my_wedding_svc",
  password: "${DB_PASS}",
  hostname: "${DB_HOST}",
  pool_size: 25

# Import secrets config
# import_config "prod.secret.exs"