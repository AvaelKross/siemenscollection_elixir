defmodule SiemensCollection.Repo.Migrations.MigrateExistingData do
  use Ecto.Migration

  alias SiemensCollection.{Repo, Phone, PhoneEdition}

  def up do
    phones = Repo.all(Phone) |> Repo.preload([:phone_editions])
    Enum.each phones, fn phone ->
      phone_edition_params = %{
        network: phone.network,
        weight: phone.weight,
        size: phone.size,
        battery: phone.battery,
        irda: String.contains?(phone.features, "IrDA"),
        bluetooth: String.contains?(phone.features, "Bluetooth"),
        gprs: String.contains?(phone.features, "GPRS")
      }

      Enum.each phone.phone_editions, fn edition ->
        changeset = PhoneEdition.changeset(edition, phone_edition_params)
        Repo.update!(changeset)
      end
    end
  end

  def down do
  end
end
