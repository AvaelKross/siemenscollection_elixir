defmodule PhonesCollectionWeb.Plugs.SetBrand do
  import Plug.Conn

  def init(_) do
    nil
  end

  def call(conn, _opts) do
    if conn.params["brand_id"] do
      brand = SiemensCollection.Repo.get(PhonesCollectionWeb.Brand, conn.params["brand_id"])
      assign(conn, :brand, brand)
    end
  end
end
