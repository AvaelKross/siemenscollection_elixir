defmodule SiemensCollection.Mixfile do
  use Mix.Project

  def project do
    [app: :siemens_collection,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {SiemensCollection, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :addict, :ex_admin, :ex_aws, :httpoison, :arc, :arc_ecto]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.1.4"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_ecto, "~> 2.0"},
     {:phoenix_html, "~> 2.4"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.9"},
     {:cowboy, "~> 1.0"},
     {:addict, github: "AvaelKross/addict"},
     {:ex_admin, github: "smpallen99/ex_admin", branch: 'ecto-1.1'},
     {:exrm, "~> 1.0.3"},
     {:arc, "~> 0.5.2", github: "AvaelKross/arc", override: true},
     {:arc_ecto, "~> 0.3.2"}, # update after updating ECTO to 2.*
     {:ex_aws, "~> 0.4.10"}, # Required for Amazon S3
     {:httpoison, "~> 0.7"}, # Required for Amazon S3
     {:poison, "~> 1.2"}     # Required for Amazon S3
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
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
