defmodule SiemensCollection.Repo.Migrations.CreatePicture do
  use Ecto.Migration

  def change do
    create table(:pictures) do
      add :url, :string
      add :phone_edition_id, references(:phone_editions, on_delete: :nothing)

      timestamps
    end
    create index(:pictures, [:phone_edition_id])

  end
end
