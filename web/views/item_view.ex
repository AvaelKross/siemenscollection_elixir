defmodule SiemensCollection.ItemView do
  use SiemensCollection.Web, :view

  def full_phone_name(edition) do
    "#{edition.phone.brand.name} #{edition.phone.name} #{edition.name}"
  end

  def can_edit(conn, item) do
    Addict.Helper.current_user(conn).id == item.user_id
  end

  def can_edit_user(conn, user) do
    Addict.Helper.current_user(conn).id == user.id
  end
end
