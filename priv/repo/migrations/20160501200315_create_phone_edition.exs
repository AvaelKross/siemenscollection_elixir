defmodule SiemensCollection.Repo.Migrations.CreatePhoneEdition do
  use Ecto.Migration

  def change do
    create table(:phone_editions) do
      add :name, :string
      add :limited, :boolean, default: false
      add :prototype, :boolean, default: false
      add :notes, :text
      add :photo_url, :string
      add :phone_id, references(:phones, on_delete: :nothing)

      timestamps
    end
    create index(:phone_editions, [:phone_id])

  end
end
