defmodule SiemensCollection.LayoutView do
  use SiemensCollection.Web, :view

  def current_user(conn) do
    Addict.Helper.current_user(conn)
  end

  def is_logged_in(conn) do
    current_user(conn) != nil
  end

  def can_edit(conn) do
    SiemensCollection.Plugs.CheckAdminRights.can_edit(conn)
  end
end
