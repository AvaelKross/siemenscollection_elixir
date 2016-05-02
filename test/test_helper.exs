ExUnit.start

Mix.Task.run "ecto.create", ~w(-r SiemensCollection.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r SiemensCollection.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(SiemensCollection.Repo)

