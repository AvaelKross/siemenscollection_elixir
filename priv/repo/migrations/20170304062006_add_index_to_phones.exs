defmodule SiemensCollection.Repo.Migrations.AddIndexToPhones do
  use Ecto.Migration

  def change do
    create unique_index(:phones, [:name])
  end
end
