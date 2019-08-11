defmodule SiemensCollection.Repo.Migrations.AddSeriesIdToPhones do
  use Ecto.Migration

  def change do
    alter table(:phones) do
      add :series_id, references(:series, on_delete: :nothing)
    end
  end
end
