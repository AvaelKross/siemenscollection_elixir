defmodule SiemensCollection.Repo do
  use Ecto.Repo,
    otp_app: :siemens_collection,
    adapter: Ecto.Adapters.Postgres
end
