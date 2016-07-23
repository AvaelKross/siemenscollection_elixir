defmodule SiemensCollection.ItemView do
  use SiemensCollection.Web, :view

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
