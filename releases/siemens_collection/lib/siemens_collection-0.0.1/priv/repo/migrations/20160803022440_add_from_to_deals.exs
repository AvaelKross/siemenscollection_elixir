defmodule SiemensCollection.Repo.Migrations.AddFromToDeals do
  use Ecto.Migration

  def change do
    alter table(:deals) do
      add :from, :string
    end
  end
end
