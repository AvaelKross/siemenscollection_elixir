defmodule SiemensCollection.Mixfile do
  use Mix.Project

  def project do
    [app: :siemens_collection,
     version: "0.0.1",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {SiemensCollection, []},
     applications: [:mix, :phoenix, :phoenix_pubsub, :phoenix_html, :logger, :gettext, :inflex, :plug_cowboy, :plug,
                    :phoenix_ecto, :ecto_sql, :postgrex, :ex_aws, :poison, :arc, :arc_ecto, :sweet_xml, :hackney]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.4.8", override: true},
     {:phoenix_pubsub, "~> 1.0"},
     {:ecto, "~> 3.1", override: true},
     {:ecto_sql, "~> 3.1"},
     {:phoenix_ecto, "~> 4.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.9"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.13"}, # I18n
     {:plug_cowboy, "~> 2.0"},
     {:plug, "~> 1.8.1"},
     {:cowboy, "~> 2.6", override: true},
     {:addict, "~> 0.3.0"}, # users
     {:distillery, ">= 0.9.0", warn_missing: false},
     {:inflex, "~> 1.7.0"}, # it's like a activesupport for strings
     {:arc, "~> 0.7.0", override: true},
     {:arc_ecto, "~> 0.11.1"},
     {:ex_aws, "~> 1.1", override: true},    # Required for Amazon S3
     {:hackney, "~> 1.7", override: true},   # Required for Amazon S3
     {:poison, "~> 3.1", override: true},    # Required for Amazon S3
     {:sweet_xml, "~> 0.6"}, # Required for Amazon S3,
     {:comeonin, "~> 4.0", override: true},
     {:guardian, "~> 0.14"}
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     test: ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
