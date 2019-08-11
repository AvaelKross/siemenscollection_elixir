defmodule SiemensCollection.Repo.Migrations.AddHideModelNameFlagToPhoneEditions do
  use Ecto.Migration

  def change do
    alter table(:phone_editions) do
      add :hide_model_name, :boolean, default: false
    end
  end
end
