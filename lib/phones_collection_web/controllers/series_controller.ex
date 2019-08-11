defmodule PhonesCollectionWeb.SeriesController do
  use SiemensCollection.Web, :controller

  alias PhonesCollectionWeb.{Series, Brand}

  plug :scrub_params, "series" when action in [:create, :update]
  plug PhonesCollectionWeb.Plugs.SetBrand

  def index(conn, _params) do
    series = Repo.all(Series)
    render(conn, "index.html", series: series)
  end

  def new(conn, _params) do
    changeset = Series.changeset(%Series{brand_id: conn.params["brand_id"]})
    brands = Repo.all(Brand)
    render(conn, "new.html", brands: brands, changeset: changeset)
  end

  def create(conn, %{"series" => series_params}) do
    changeset = Series.changeset(%Series{}, series_params)

    case Repo.insert(changeset) do
      {:ok, _series} ->
        conn
        |> put_flash(:info, "Series created successfully.")
        |> redirect(to: Routes.catalog_phone_path(conn, :index, conn.assigns.brand))
      {:error, changeset} ->
        brands = Repo.all(Brand)
        render(conn, "new.html", brands: brands, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    series = Repo.get!(Series, id)
    render(conn, "show.html", series: series)
  end

  def edit(conn, %{"id" => id}) do
    series = Repo.get!(Series, id)
    changeset = Series.changeset(series)
    brands = Repo.all(Brand)
    render(conn, "edit.html", brands: brands, series: series, changeset: changeset)
  end

  def update(conn, %{"id" => id, "series" => series_params}) do
    series = Repo.get!(Series, id)
    changeset = Series.changeset(series, series_params)

    case Repo.update(changeset) do
      {:ok, series} ->
        conn
        |> put_flash(:info, "Series updated successfully.")
        |> redirect(to: Routes.catalog_phone_path(conn, :index, conn.assigns.brand))
      {:error, changeset} ->
        render(conn, "edit.html", series: series, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    series = Repo.get!(Series, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(series)

    conn
    |> put_flash(:info, "Series deleted successfully.")
    |> redirect(to: Routes.catalog_phone_path(conn, :index, conn.assigns.brand))
  end
end
