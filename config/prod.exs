use Mix.Config

config :my_wedding, MyWedding.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "wedding.nikkomiu.com", port: 443],
  cache_static_manifest: "priv/static/manifest.json"

# Logging
config :logger, level: :info

# Releases
config :phoenix, :serve_endpoints, true
config :my_wedding, MyWedding.Endpoint, root: "."

# Secret Key Base
config :my_wedding, MyWedding.Endpoint,
  secret_key_base: "${SECRET_KEY_BASE}"

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [callback_url: "https://wedding.nikkomiu.com/auth/google/callback"]}
  ]

# Configures Ueberauth OAuth Google Strategy
config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "${GOOGLE_CLIENT_ID}",
  client_secret: "${GOOGLE_CLIENT_SECRET}"

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
