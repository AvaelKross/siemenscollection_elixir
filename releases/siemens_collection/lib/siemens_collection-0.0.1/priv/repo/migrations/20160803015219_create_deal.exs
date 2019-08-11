defmodule SiemensCollection.Repo.Migrations.CreateDeal do
  use Ecto.Migration

  def change do
    create table(:deals) do
      add :phone_edition_id, :integer
      add :user_id, :integer
      add :link, :text
      add :contact_name, :string
      add :contact_email, :string
      add :contact_phone, :string
      add :price, :string
      add :status, :string
      add :notes, :text

      timestamps
    end

  end
end
