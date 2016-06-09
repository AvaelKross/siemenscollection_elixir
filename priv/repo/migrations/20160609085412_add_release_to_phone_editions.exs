defmodule SiemensCollection.Repo.Migrations.AddReleaseToPhoneEditions do
  use Ecto.Migration

  def change do
    alter table(:phone_editions) do
      add :release, :string
    end
  end
end
