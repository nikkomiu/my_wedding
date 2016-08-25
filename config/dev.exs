use Mix.Config

# Disable any cache and enable debugging and code reloading.
config :my_wedding, MyWedding.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]

config :my_wedding,
  :environment, :dev

# Watch static and templates for browser reloading.
config :my_wedding, MyWedding.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/(assets|images|svg).*(js|scss|sass|css|png|jpeg|jpg|gif|svg)$},
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
config :my_wedding, MyWedding.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "ecto://postgres:postgres@192.168.99.100:5432/my_wedding_dev",
  pool_size: 10
