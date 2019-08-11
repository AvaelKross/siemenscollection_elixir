defmodule SiemensCollection.Repo.Migrations.AddImageFieldToPictures do
  use Ecto.Migration

  def change do
    alter table(:pictures) do
      add :image, :string
    end
  end
end
