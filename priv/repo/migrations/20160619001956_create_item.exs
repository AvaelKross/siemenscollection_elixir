defmodule SiemensCollection.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :notes, :text
      add :condition, :integer
      add :released, :string
      add :imei, :string
      add :sw, :string
      add :made_in, :string
      add :calls_time, :string
      add :set, :text
      add :selling, :boolean, default: false
      add :phone_edition_id, references(:phone_editions, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:items, [:phone_edition_id])
    create index(:items, [:user_id])

  end
end
