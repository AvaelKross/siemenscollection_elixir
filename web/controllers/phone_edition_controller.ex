defmodule SiemensCollection.PhoneEditionController do
  use SiemensCollection.Web, :controller

  alias SiemensCollection.PhoneEdition

  plug :scrub_params, "phone_edition" when action in [:create, :update]

  def index(conn, _params) do
    phone_editions = Repo.all(PhoneEdition)
    render(conn, "index.html", phone_editions: phone_editions)
  end

  def new(conn, _params) do
    changeset = PhoneEdition.changeset(%PhoneEdition{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"phone_edition" => phone_edition_params}) do
    changeset = PhoneEdition.changeset(%PhoneEdition{}, phone_edition_params)

    case Repo.insert(changeset) do
      {:ok, _phone_edition} ->
        conn
        |> put_flash(:info, "Phone edition created successfully.")
        |> redirect(to: phone_edition_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    phone_edition = Repo.get!(PhoneEdition, id)
    render(conn, "show.html", phone_edition: phone_edition)
  end

  def edit(conn, %{"id" => id}) do
    phone_edition = Repo.get!(PhoneEdition, id)
    changeset = PhoneEdition.changeset(phone_edition)
    render(conn, "edit.html", phone_edition: phone_edition, changeset: changeset)
  end

  def update(conn, %{"id" => id, "phone_edition" => phone_edition_params}) do
    phone_edition = Repo.get!(PhoneEdition, id)
    changeset = PhoneEdition.changeset(phone_edition, phone_edition_params)

    case Repo.update(changeset) do
      {:ok, phone_edition} ->
        conn
        |> put_flash(:info, "Phone edition updated successfully.")
        |> redirect(to: phone_edition_path(conn, :show, phone_edition))
      {:error, changeset} ->
        render(conn, "edit.html", phone_edition: phone_edition, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    phone_edition = Repo.get!(PhoneEdition, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(phone_edition)

    conn
    |> put_flash(:info, "Phone edition deleted successfully.")
    |> redirect(to: phone_edition_path(conn, :index))
  end
end
