defmodule SiemensCollection.Repo.Migrations.CreateSeries do
  use Ecto.Migration

  def change do
    create table(:series) do
      add :name, :string
      add :brand_id, references(:brands, on_delete: :nothing)

      timestamps
    end
    create index(:series, [:brand_id])

  end
end
