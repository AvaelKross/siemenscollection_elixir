defmodule SiemensCollection.Repo.Migrations.SetMainEditionForAllPhones do
  use Ecto.Migration

  alias SiemensCollection.{Repo, Phone}

  def up do
    phones = Repo.all(Phone) |> Repo.preload([:phone_editions])
    Enum.each phones, fn phone ->
      default = Enum.filter(phone.phone_editions, fn(n) -> String.contains?(n.name, "Default") end)
      main_edition = if length(default) > 0, do: Enum.at(default, 0), else: Enum.at(phone.phone_editions, 0)
      changeset = Phone.changeset(phone, %{main_edition_id: main_edition.id})
      Repo.update!(changeset)
    end
  end

  def down do
  end
end
