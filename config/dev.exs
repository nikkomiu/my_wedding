use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application.
config :my_wedding, MyWedding.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]

# Watch static and templates for browser reloading.
config :my_wedding, MyWedding.Endpoint,
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
config :my_wedding, MyWedding.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "my_wedding_svc",
  password: "weddingpassword",
  database: "my_wedding_dev",
  hostname: "192.168.99.100",
  pool_size: 10
