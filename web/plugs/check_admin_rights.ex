defmodule SiemensCollection.Plugs.CheckAdminRights do
  import Plug.Conn
  import Phoenix.Controller

  def init(_) do
    nil
  end

  def call(conn, _opts) do
    if can_edit(conn) do
      conn
    else
      conn
      |> put_flash(:info, "You have no rights to do it")
      |> redirect(to: SiemensCollection.Router.Helpers.catalog_brand_path(conn, :index))
    end
  end

  def can_edit(conn) do
    current_user(conn) != nil && current_user(conn).email == "avaelkross@gmail.com"
  end

  defp current_user(conn) do
    Addict.Helper.current_user(conn)
  end
end