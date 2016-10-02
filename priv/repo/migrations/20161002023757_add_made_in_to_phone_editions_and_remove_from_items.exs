defmodule SiemensCollection.Repo.Migrations.AddMadeInToPhoneEditionsAndRemoveFromItems do
  use Ecto.Migration

  def up do
    alter table(:phone_editions) do
      add :made_in, :string
    end
    alter table(:items) do
      remove :made_in
    end
  end

  def down do
    alter table(:phone_editions) do
      remove :made_in
    end
    alter table(:items) do
      add :made_in, :string
    end
  end
end
