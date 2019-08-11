use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :siemens_collection, PhonesCollectionWeb.Endpoint,
  http: [port: 4001],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
             cd: Path.expand("../assets", __DIR__)]]

# Watch static and templates for browser reloading.
config :siemens_collection, PhonesCollectionWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/phones_collection_web/views/.*(ex)$},
      ~r{lib/phones_collection_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :siemens_collection, SiemensCollection.Repo,
  username: "siemens",
  password: "siemens",
  database: "siemens_collection_dev",
  hostname: "localhost",
  pool_size: 10

config :arc,
  storage: Arc.Storage.S3,
  bucket: "siemenscollection-uploads-d",
  asset_host: "https://s3.eu-central-1.amazonaws.com/siemenscollection-uploads-d/",
  version_timeout: 40_000
