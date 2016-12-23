defmodule MyWedding.Mixfile do
  use Mix.Project

  def project do
    [app: :my_wedding,
     version: "0.0.1",
     elixir: "~> 1.2",
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test],
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  def application do
    [mod: {MyWedding, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger,
                    :ueberauth_google, :guardian, :phoenix_inline_svg, :earmark,
                    :gettext, :phoenix_ecto, :postgrex, :phoenix_haml, :mogrify,
                    :httpotion]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  defp deps do
    [{:phoenix, "~> 1.2.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:phoenix_haml, "~> 0.2.1"},
     {:exrm, "~> 1.0"},
     {:mogrify, "~> 0.3"},
     {:earmark, "~> 1.0"},
     {:httpotion, "~> 3.0"},
     {:guardian, "~> 0.12"},
     {:ueberauth_google, "~> 0.2"},
     {:phoenix_inline_svg, "~> 0.2"},
     {:inch_ex, "~> 0.5", only: [:dev, :test]},     # Improve docs
     {:credo, "~> 0.5", only: [:dev, :test]},       # Static code analysis
     {:excoveralls, "~> 0.5", only: [:dev, :test]}] # Test coverage
  end

  # Aliases are shortcuts or tasks specific to the current project.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
