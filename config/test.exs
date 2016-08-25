use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :my_wedding, MyWedding.Endpoint,
  http: [port: 4001],
  server: false

config :my_wedding, :environment, :test

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :my_wedding, MyWedding.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "ecto://my_wedding_svc:postgres@postgres/my_wedding_test",
  pool: Ecto.Adapters.SQL.Sandbox
