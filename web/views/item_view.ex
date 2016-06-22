defmodule SiemensCollection.ItemView do
  use SiemensCollection.Web, :view

  def full_phone_name(edition) do
    "#{edition.phone.brand.name} #{edition.phone.name} #{edition.name}"
  end
end
