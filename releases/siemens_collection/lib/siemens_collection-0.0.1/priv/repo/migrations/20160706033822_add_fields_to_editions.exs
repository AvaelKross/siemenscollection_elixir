defmodule SiemensCollection.Repo.Migrations.AddFieldsToEditions do
  use Ecto.Migration

  def change do
    alter table(:phone_editions) do
      add :form_factor, :string
      add :java, :boolean, default: true
      add :lte, :boolean, default: false
      add :"3g", :boolean, default: false
      add :memory_card_support, :boolean, default: false
      add :memory_card_type, :string
      add :irda, :boolean, default: false
      add :bluetooth, :boolean, default: false
      add :gprs, :boolean, default: false
      add :network, :string
      add :weight, :string
      add :size, :string
      add :battery, :string
    end
  end
end
