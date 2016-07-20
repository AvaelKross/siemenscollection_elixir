defmodule SiemensCollection.Repo.Migrations.AddFullSetFlagToItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :full_set, :boolean, default: false
    end
  end
end
