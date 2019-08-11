defmodule PhonesCollectionWeb.BrandView do
  use SiemensCollection.Web, :view

  def can_edit(conn) do
    PhonesCollectionWeb.Plugs.CheckAdminRights.can_edit(conn)
  end
end
