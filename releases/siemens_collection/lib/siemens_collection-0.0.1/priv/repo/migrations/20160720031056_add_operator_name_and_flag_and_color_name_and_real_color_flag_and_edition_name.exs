defmodule SiemensCollection.Repo.Migrations.AddOperatorNameAndFlagAndColorNameAndRealColorFlagAndEditionName do
  use Ecto.Migration

  def change do
    rename table(:phone_editions), :real_name, to: :real_name_flag
    alter table(:phone_editions) do
      add :operator_edition, :boolean, default: false
      add :operator_name, :string
      add :color_name, :string
      add :real_color_name, :boolean, default: false
      add :real_name, :string
    end
  end
end
