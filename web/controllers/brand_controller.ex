defmodule SiemensCollection.BrandController do
  use SiemensCollection.Web, :controller

  alias SiemensCollection.Brand

  plug SiemensCollection.Plugs.CheckAdminRights when action in [:new, :create, :edit, :update, :delete]

  plug :scrub_params, "brand" when action in [:create, :update]

  def index(conn, _params) do
    brands = from(Brand, order_by: [asc: :name]) |> Repo.all
    render(conn, "index.html", brands: brands)
  end

  def new(conn, _params) do
    changeset = Brand.changeset(%Brand{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"brand" => brand_params}) do
    changeset = Brand.changeset(%Brand{}, brand_params)

    case Repo.insert(changeset) do
      {:ok, _brand} ->
        conn
        |> put_flash(:info, "Brand created successfully.")
        |> redirect(to: brand_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    brand = Repo.get!(Brand, id)
    changeset = Brand.changeset(brand)
    render(conn, "edit.html", brand: brand, changeset: changeset)
  end

  def update(conn, %{"id" => id, "brand" => brand_params}) do
    brand = Repo.get!(Brand, id)
    changeset = Brand.changeset(brand, brand_params)

    case Repo.update(changeset) do
      {:ok, _brand} ->
        conn
        |> put_flash(:info, "Brand updated successfully.")
        |> redirect(to: brand_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    brand = Repo.get!(Brand, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(brand)

    conn
    |> put_flash(:info, "Brand deleted successfully.")
    |> redirect(to: brand_path(conn, :index))
  end
end
