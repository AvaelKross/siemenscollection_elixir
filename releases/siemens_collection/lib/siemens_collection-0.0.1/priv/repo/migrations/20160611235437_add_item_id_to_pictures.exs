defmodule SiemensCollection.Repo.Migrations.AddItemIdToPictures do
  use Ecto.Migration

  def change do
    alter table(:pictures) do
      add :item_id, :integer
    end
  end
end
