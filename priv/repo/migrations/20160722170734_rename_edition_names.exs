defmodule SiemensCollection.Repo.Migrations.RenameEditionNames do
  use Ecto.Migration

  def change do
    rename table(:phone_editions), :real_name, to: :additional_name
  end
end
