defmodule SiemensCollection.Repo.Migrations.CreatePhone do
  use Ecto.Migration

  def change do
    create table(:phones) do
      add :name, :string
      add :network, :string
      add :features, :text
      add :weight, :string
      add :size, :string
      add :battery, :string
      add :notes, :text
      add :release, :string
      add :brand_id, references(:brands, on_delete: :nothing)

      timestamps
    end
    create index(:phones, [:brand_id])

  end
end
