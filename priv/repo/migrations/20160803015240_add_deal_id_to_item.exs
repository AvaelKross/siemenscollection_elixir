defmodule SiemensCollection.Repo.Migrations.AddDealIdToItem do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :deal_id, references(:deals, on_delete: :nothing)
    end
  end
end
