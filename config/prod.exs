use Mix.Config

config :wedding_website, WeddingWebsite.Endpoint,
  http: [port: 8080],
  url: [host: "WeddingWebsite.nikkomiu.com", port: 80],
  cache_static_manifest: "priv/static/manifest.json"

# Logging
config :logger, level: :info

# Releases
config :phoenix, :serve_endpoints, true
config :wedding_website, WeddingWebsite.Endpoint, root: "."

# Secret Key Base
config :wedding_website, WeddingWebsite.Endpoint,
  secret_key_base: "${SECRET_KEY_BASE}"

# Database
config :wedding_website, WeddingWebsite.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "${DB_USER}",
  password: "${DB_PASS}",
  database: "${DB_BASE}",
  hostname: "${DB_HOST}",
  pool_size: 25

# Import secrets config
# import_config "prod.secret.exs"
