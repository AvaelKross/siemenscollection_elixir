defmodule PhonesCollectionWeb.CollectionView do
  use SiemensCollection.Web, :view

  def can_edit_admin(conn, user) do
    PhonesCollectionWeb.Plugs.CheckAdminRights.can_edit_user(conn, user)
  end
end
