defmodule SiemensCollection.PhoneController do
  use SiemensCollection.Web, :controller

  alias SiemensCollection.Repo

  alias SiemensCollection.Phone
  alias SiemensCollection.PhoneEdition
  alias SiemensCollection.Brand

  plug Addict.Plugs.Authenticated when action in [:new, :create, :edit, :update, :delete]
  plug :check_rights when action in [:new, :create, :edit, :update, :delete]

  plug :scrub_params, "phone" when action in [:create, :update]
  plug :set_brand
  
  def index(conn, _params) do
    query = from p in Phone, where: p.brand_id == ^conn.assigns.brand.id
    phones = Repo.all(query)
    render(conn, "index.html", phones: phones)
  end

  def new(conn, _params) do
    changeset = Phone.changeset(%Phone{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"phone" => phone_params}) do
    changeset = Phone.changeset(%Phone{}, phone_params)

    case Repo.insert(changeset) do
      {:ok, _phone} ->
        conn
        |> put_flash(:info, "Phone created successfully.")
        |> redirect(to: short_phone_path(conn, :index, conn.assigns.brand.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    phone = Repo.get!(Phone, id) |> Repo.preload([:brand])
    query = from pe in PhoneEdition, where: pe.phone_id == ^phone.id
    editions = Repo.all(query)
    render(conn, "show.html", phone: phone, editions: editions)
  end

  def edit(conn, %{"id" => id}) do
    phone = Repo.get!(Phone, id)
    changeset = Phone.changeset(phone)
    render(conn, "edit.html", phone: phone, changeset: changeset)
  end

  def update(conn, %{"id" => id, "phone" => phone_params}) do
    phone = Repo.get!(Phone, id)
    changeset = Phone.changeset(phone, phone_params)

    case Repo.update(changeset) do
      {:ok, phone} ->
        conn
        |> put_flash(:info, "Phone updated successfully.")
        |> redirect(to: short_phone_path(conn, :show, conn.assigns.brand.id, phone))
      {:error, changeset} ->
        render(conn, "edit.html", phone: phone, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    phone = Repo.get!(Phone, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(phone)

    conn
    |> put_flash(:info, "Phone deleted successfully.")
    |> redirect(to: short_phone_path(conn, :index, conn.assigns.brand.id))
  end

  defp set_brand(conn, _) do
    if conn.params["brand_id"] do
      brand = Repo.get(Brand, conn.params["brand_id"])
      assign(conn, :brand, brand)
    else
      conn
    end
  end

  defp check_rights(conn, _) do
    if Addict.Helper.current_user(conn) && Addict.Helper.current_user(conn).email != "avaelkross@gmail.com" do
      conn
      |> put_flash(:info, "You have no rights to do it")
      |> redirect(to: brand_path(conn, :index))
    else
      conn
    end
  end
end
