use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application.
config :wedding_website, WeddingWebsite.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]

# Watch static and templates for browser reloading.
config :wedding_website, WeddingWebsite.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|scss|sass|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex|haml)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :wedding_website, WeddingWebsite.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "wedding_website_svc",
  password: "weddingpassword",
  database: "wedding_website_dev",
  hostname: "192.168.99.100",
  pool_size: 10
