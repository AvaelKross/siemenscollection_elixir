defmodule SiemensCollection.Repo.Migrations.CreateBrand do
  use Ecto.Migration

  def change do
    create table(:brands) do
      add :name, :string

      timestamps
    end

  end
end
