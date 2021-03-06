# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :siemens_collection, SiemensCollection.Endpoint,
  url: [host: "localhost"],
  ecto_repos: [SiemensCollection.Repo],
  secret_key_base: "+E+SMepQ+DNQ1zjeSjbiyBFUTinc94ZuKRjKz6VCLAf28vwRVvStN5uYWTNDb6RY",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: SiemensCollection.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :siemens_collection, ecto_repos: [SiemensCollection.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :addict,
  secret_key: "24326224313224416248435730693841675759536a3642347161584b4f",
  extra_validation: {SiemensCollection.User, :addict_validate},
  user_schema: SiemensCollection.User,
  repo: SiemensCollection.Repo,
  from_email: "no-reply@siemenscollection.ru", # CHANGE THIS
  mail_service: nil

config :ex_aws,
  access_key_id: "AKIAIM7J52PY7JYEVISA",
  secret_access_key: "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",
  region: "eu-central-1",
  s3: [
    scheme: "https://",
    host: "s3.eu-central-1.amazonaws.com",
    region: "eu-central-1"
  ]
