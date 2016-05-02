defmodule SiemensCollection.Repo do
  use Ecto.Repo, otp_app: :siemens_collection
  use Scrivener, page_size: 25
end
