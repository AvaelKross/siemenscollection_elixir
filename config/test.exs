use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :siemens_collection, SiemensCollection.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :siemens_collection, SiemensCollection.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "siemens",
  password: "siemens",
  database: "siemens_collection_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
