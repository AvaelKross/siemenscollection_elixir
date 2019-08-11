defmodule SiemensCollection.Repo.Migrations.AddRealNameFlagToPhoneEditions do
  use Ecto.Migration

  def change do
    alter table(:phone_editions) do
      add :real_name, :boolean, default: false
    end
  end
end
