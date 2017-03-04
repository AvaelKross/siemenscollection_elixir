defmodule SiemensCollection.Repo.Migrations.AddIndexToBrands do
  use Ecto.Migration

  def change do
    create unique_index(:brands, [:name])
  end
end
