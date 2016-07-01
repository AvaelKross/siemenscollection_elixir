defmodule SiemensCollection.ItemView do
  use SiemensCollection.Web, :view

  def full_phone_name(edition) do
    "#{edition.phone.brand.name} #{edition.phone.name} #{edition.name}"
  end

  def can_edit(conn) do
    SiemensCollection.Plugs.CheckOwnerRights.can_edit(conn)
  end
end
