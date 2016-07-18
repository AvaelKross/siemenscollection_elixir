defmodule SiemensCollection.ItemView do
  use SiemensCollection.Web, :view

  def full_phone_name(edition, separator \\ "") do
    if edition.hide_model_name do
      "#{edition.phone.brand.name} #{edition.name}"
    else
      if edition.name == "Default" || edition.name == "(Default)" do
        "#{edition.phone.brand.name} #{edition.phone.name}"
      else
        "#{edition.phone.brand.name} #{edition.phone.name} #{separator}#{edition.name}"
      end
    end
  end

  def can_edit_admin(conn, user) do
    SiemensCollection.Plugs.CheckAdminRights.can_edit_user(conn, user)
  end

  def can_edit(conn, item) do
    current_user_id(conn) == item.user_id
  end

  def can_edit_user(conn, user) do
    current_user_id(conn) == user.id
  end

  def current_user_id(conn) do
    if Addict.Helper.current_user(conn) do
      Addict.Helper.current_user(conn).id
    else
      nil
    end
  end
end
