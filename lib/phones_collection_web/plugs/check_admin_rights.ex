defmodule PhonesCollectionWeb.Plugs.CheckAdminRights do
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(_) do
    nil
  end

  def call(conn, _opts) do
    if can_edit(conn) do
      conn
    else
      conn
      |> put_flash(:info, "You have no rights to do it")
      |> redirect(to: PhonesCollectionWeb.Router.Helpers.brand_path(conn, :index))
    end
  end

  def can_edit(conn) do
    current_user(conn) != nil && current_user(conn).role == "Admin"
  end

  def can_edit_user(conn, user) do
    can_edit(conn) && current_user(conn).id != user.id
  end

  defp current_user(conn) do
    Addict.Helper.current_user(conn)
  end
end
