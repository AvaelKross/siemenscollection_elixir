defmodule PhonesCollectionWeb.PhoneController do
  use SiemensCollection.Web, :controller

  alias PhonesCollectionWeb.{Phone, PhoneEdition, Item}

  plug PhonesCollectionWeb.Plugs.CheckAdminRights when action in [:new, :create, :edit, :update, :delete, :set_main_edition]

  plug :scrub_params, "phone" when action in [:create, :update]
  plug PhonesCollectionWeb.Plugs.SetBrand

  def index(conn, _params) do
    brand_id = conn.assigns.brand.id
    query = Phone |> Phone.for_brand(brand_id) |> Phone.editions_count
    query = from query, preload: [:series, [main_edition: [:cover, :pictures]]]
    query = from query, order_by: [asc: :name]
    phones = Repo.all(query)

    # Refactor this please

    phones_by_series = phones
    |> Enum.group_by(fn e ->
                        [elem(e, 0).series_id,
                         (if elem(e, 0).series, do: elem(e, 0).series.name, else: nil)]
                     end)
    |> Enum.sort(fn e1, e2 -> Enum.at(elem(e2, 0), 1) |> case do
                                                        nil -> Enum.at(elem(e1, 0), 1) > Enum.at(elem(e2, 0), 1)
                                                        _ -> Enum.at(elem(e1, 0), 1) < Enum.at(elem(e2, 0), 1)
                                                      end
                 end)

    render(conn, "index.html", phones_by_series: phones_by_series)
  end

  def new(conn, _params) do
    brands = Repo.all(PhonesCollectionWeb.Brand)
    changeset = Phone.changeset_on_create(%Phone{phone_editions: [%PhoneEdition{}]})
    series = Repo.all(from s in PhonesCollectionWeb.Series, where: s.brand_id == ^conn.assigns.brand.id)
    render(conn, "new.html", brands: brands, series: series, changeset: changeset)
  end

  def create(conn, %{"phone" => phone_params}) do
    changeset = Phone.changeset_on_create(%Phone{}, phone_params)

    case Repo.insert(changeset) do
      {:ok, phone} ->
        # set main edition
        edition = Enum.at phone.phone_editions, 0
        changeset = Phone.changeset(phone, %{main_edition_id: edition.id})
        {:ok, _} = Repo.update(changeset)

        redirect_path = if conn.params["save_and_upload"] != nil do
          Routes.catalog_picture_path(conn, :new, conn.assigns.brand.id, phone.id, edition.id)
        else
          Routes.catalog_phone_path(conn, :index, conn.assigns.brand.id)
        end

        conn
        |> put_flash(:info, "Phone created successfully.")
        |> redirect(to: redirect_path)
      {:error, changeset} ->
        brands = Repo.all(PhonesCollectionWeb.Brand)
        series = Repo.all(from s in PhonesCollectionWeb.Series, where: s.brand_id == ^conn.assigns.brand.id)
        render(conn, "new.html", brands: brands, series: series, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    phone = Repo.get!(Phone, id) |> Repo.preload([:brand, main_edition: [:pictures, :cover]])
    query = from pe in PhoneEdition, where: pe.phone_id == ^phone.id, preload: [:phone, :pictures, :cover]
    editions = Repo.all(query)
    main_edition = if phone.main_edition != nil do
      phone.main_edition
    else
      List.first editions
    end
    render(conn, "show.html", phone: phone, phone_edition: main_edition, editions: editions)
  end

  def edit(conn, %{"id" => id}) do
    brands = Repo.all(PhonesCollectionWeb.Brand)
    phone = Repo.get!(Phone, id)
    changeset = Phone.changeset(phone)
    series = Repo.all(from s in PhonesCollectionWeb.Series, where: s.brand_id == ^conn.assigns.brand.id)
    render(conn, "edit.html", brands: brands, series: series, phone: phone, changeset: changeset)
  end

  def update(conn, %{"id" => id, "phone" => phone_params}) do
    phone = Repo.get!(Phone, id)
    changeset = Phone.changeset(phone, phone_params)

    case Repo.update(changeset) do
      {:ok, phone} ->
        conn
        |> put_flash(:info, "Phone updated successfully.")
        |> redirect(to: Routes.catalog_phone_path(conn, :show, conn.assigns.brand.id, phone))
      {:error, changeset} ->
        brands = Repo.all(PhonesCollectionWeb.Brand)
        series = Repo.all(from s in PhonesCollectionWeb.Series, where: s.brand_id == ^conn.assigns.brand.id)
        render(conn, "edit.html", brands: brands, series: series, phone: phone, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    phone = Repo.get!(Phone, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(phone)

    conn
    |> put_flash(:info, "Phone deleted successfully.")
    |> redirect(to: Routes.catalog_phone_path(conn, :index, conn.assigns.brand.id))
  end

  def set_main_edition(conn, %{"phone_id" => id, "edition_id" => edition_id}) do
    phone = Repo.get!(Phone, id)
    changeset = Phone.changeset(phone, %{main_edition_id: edition_id})

    case Repo.update(changeset) do
      {:ok, phone} ->
        conn
        |> put_flash(:info, "Main edition updated successfully.")
        |> redirect(to: Routes.catalog_phone_path(conn, :show, conn.assigns.brand.id, phone))
      {:error, changeset} ->
        render(conn, "edit.html", phone: phone, changeset: changeset)
    end
  end

end
