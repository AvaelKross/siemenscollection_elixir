defmodule SiemensCollection.Repo.Migrations.AddMainEditionIdToPhones do
  use Ecto.Migration

  def change do
    alter table(:phones) do
      add :main_edition_id, :integer
    end
  end
end
