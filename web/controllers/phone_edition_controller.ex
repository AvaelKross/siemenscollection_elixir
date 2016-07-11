defmodule SiemensCollection.PhoneEditionController do
  use SiemensCollection.Web, :controller

  alias SiemensCollection.{Phone, PhoneEdition}

  plug :scrub_params, "phone_edition" when action in [:create, :update]

  plug SiemensCollection.Plugs.CheckAdminRights when action in [:new, :create, :edit, :update, :delete]

  plug SiemensCollection.Plugs.SetBrand
  plug :set_phone

  def new(conn, _params) do
    main_edition = Repo.get!(PhoneEdition, conn.assigns.phone.main_edition_id)
    changeset = PhoneEdition.changeset(%PhoneEdition{}, Map.from_struct(main_edition))

    phones = Repo.all(Phone) |> Repo.preload([:brand])
    render(conn, "new.html", phones: phones, changeset: changeset)
  end

  def create(conn, %{"phone_edition" => phone_edition_params}) do
    changeset = PhoneEdition.changeset(%PhoneEdition{}, phone_edition_params)

    case Repo.insert(changeset) do
      {:ok, phone_edition} ->
        redirect_path = if conn.params["save_and_upload"] != nil do
          catalog_picture_path(conn, :new, conn.assigns.brand.id, conn.assigns.phone.id, phone_edition.id)
        else
          catalog_phone_path(conn, :show, conn.assigns.brand.id, conn.assigns.phone.id)
        end
        conn
        |> put_flash(:info, "Phone edition created successfully.")
        |> redirect(to: redirect_path)
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    phones = Repo.all(Phone) |> Repo.preload([:brand])
    phone_edition = Repo.get!(PhoneEdition, id) |> Repo.preload([:pictures])
    changeset = PhoneEdition.changeset(phone_edition)
    render(conn, "edit.html", phones: phones, phone_edition: phone_edition, changeset: changeset)
  end

  def update(conn, %{"id" => id, "phone_edition" => phone_edition_params}) do
    phone_edition = Repo.get!(PhoneEdition, id)
    changeset = PhoneEdition.changeset(phone_edition, phone_edition_params)

    case Repo.update(changeset) do
      {:ok, _phone_edition} ->
        conn
        |> put_flash(:info, "Phone edition updated successfully.")
        |> redirect(to: catalog_phone_path(conn, :show, conn.assigns.brand.id, conn.assigns.phone.id))
      {:error, changeset} ->
        render(conn, "edit.html", phone_edition: phone_edition, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    phone_edition = Repo.get!(PhoneEdition, id)

    Repo.delete!(phone_edition)

    conn
    |> put_flash(:info, "Phone edition deleted successfully.")
    |> redirect(to: catalog_phone_path(conn, :show, conn.assigns.brand.id, conn.assigns.phone.id))
  end

  defp set_phone(conn, _) do
    if conn.params["phone_id"] do
      phone = Repo.get(Phone, conn.params["phone_id"])
      assign(conn, :phone, phone)
    else
      conn
    end
  end
end
