defmodule SiemensCollection.BrandView do
  use SiemensCollection.Web, :view

  def can_edit(conn) do
    SiemensCollection.Plugs.CheckAdminRights.can_edit(conn)
  end
end
