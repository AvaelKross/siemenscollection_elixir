defmodule SiemensCollection.Tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:demo)

    path = Application.app_dir(:demo, "priv/repo/migrations")

    Ecto.Migrator.run(Demo.Repo, path, :up, all: true)
  end
end
