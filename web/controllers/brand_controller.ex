defmodule SiemensCollection.BrandController do
  use SiemensCollection.Web, :controller

  alias SiemensCollection.Brand

  def index(conn, _params) do
    brands = Repo.all(Brand)
    render(conn, "index.html", brands: brands)
  end
end
