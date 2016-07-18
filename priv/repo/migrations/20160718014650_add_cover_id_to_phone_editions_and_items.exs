defmodule SiemensCollection.Repo.Migrations.AddCoverIdToPhoneEditionsAndItems do
  use Ecto.Migration

  def change do
    alter table(:phone_editions) do
      add :cover_id, :integer
    end
    alter table(:items) do
      add :cover_id, :integer
    end
  end
end
