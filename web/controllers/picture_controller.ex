defmodule SiemensCollection.PictureController do
  use SiemensCollection.Web, :controller

  alias SiemensCollection.PhoneEdition
  alias SiemensCollection.Picture
  alias SiemensCollection.Image

  plug :scrub_params, "images" when action in [:create]
  plug Addict.Plugs.Authenticated when action in [:new, :create, :delete]

  plug :check_rights when action in [:new, :create, :delete]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"images" => images_params}) do
    Enum.each images_params["images_from_pc"], fn n ->
      if n != nil && n != "" do
        changeset = Picture.changeset(%Picture{}, %{phone_edition_id: conn.params["edition_id"]})
        {:ok, picture} = Repo.insert(changeset)
        changeset = Picture.changeset(picture, %{image: n})
        {:ok, _} = Repo.update(changeset)
      end
    end

    Enum.each images_params["images_from_link"], fn n ->
      if n != nil && n != "" do
        changeset = Picture.changeset(%Picture{}, %{phone_edition_id: conn.params["edition_id"]})
        {:ok, picture} = Repo.insert(changeset)
        changeset = Picture.changeset(picture, %{image: n})
        {:ok, _} = Repo.update(changeset)
      end
    end

    conn
    |> put_flash(:info, "Images uploaded successfully.")
    |> redirect(to: short_phone_edition_path(conn, :edit, conn.params["brand_id"],
                                                          conn.params["phone_id"],
                                                          conn.params["edition_id"]))
  end

  def delete(conn, %{"id" => id}) do
    picture = Repo.get!(Picture, id)

    if picture.image != nil do
      :ok = Image.delete({picture.image.file_name, picture})
    end

    Repo.delete!(picture)

    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: short_phone_edition_path(conn, :edit, conn.params["brand_id"],
                                                          conn.params["phone_id"],
                                                          conn.params["edition_id"]))
  end

  defp check_rights(conn, _) do
    if Addict.Helper.current_user(conn) && Addict.Helper.current_user(conn).email != "avaelkross@gmail.com" do
      conn
      |> put_flash(:info, "You have no rights to do it")
      |> redirect(to: short_brand_path(conn, :index))
    else
      conn
    end
  end
end