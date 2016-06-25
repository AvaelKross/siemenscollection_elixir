defmodule SiemensCollection.PictureController do
  use SiemensCollection.Web, :controller

  alias SiemensCollection.PhoneEdition
  alias SiemensCollection.Picture
  alias SiemensCollection.Image

  plug :scrub_params, "images" when action in [:create]
  plug :redirect_path when action in [:create, :delete]

  plug :check_rights when action in [:new, :create, :delete]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"images" => images_params}) do
    if conn.params["edition_id"] != nil do
      picture_hash = %{phone_edition_id: conn.params["edition_id"]}
    else
      picture_hash = %{item_id: conn.params["item_id"]}
    end

    Enum.each images_params, fn n ->
      if n != nil && n != "" do
        changeset = Picture.changeset(%Picture{}, picture_hash)
        {:ok, picture} = Repo.insert(changeset)
        changeset = Picture.changeset(picture, %{image: n})
        {:ok, _} = Repo.update(changeset)
      end
    end

    conn
    |> put_flash(:info, "Images uploaded successfully.")
    |> redirect(to: conn.assigns.redirect_path)
  end

  def delete(conn, %{"id" => id}) do
    picture = Repo.get!(Picture, id)

    if picture.image != nil do
      :ok = Image.delete({picture.image.file_name, picture})
    end

    Repo.delete!(picture)

    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: conn.assigns.redirect_path)
  end

  defp redirect_path(conn, _) do
    if conn.params["edition_id"] != nil do
      path = catalog_phone_edition_path(conn, :edit, conn.params["brand_id"],
                                                     conn.params["phone_id"],
                                                     conn.params["edition_id"])
    else
      path = collections_item_path(conn, :edit, conn.params["user_id"],
                                                conn.params["item_id"])
    end
    assign(conn, :redirect_path, path)
  end

  defp check_rights(conn, _) do
    if Addict.Helper.current_user(conn) do
      if conn.params["edition_id"] != nil do
        if SiemensCollection.Plugs.CheckAdminRights.can_edit(conn) do
          success = true
        else
          success = false
        end
      else
        if Integer.to_string(Addict.Helper.current_user(conn).id) == conn.params["user_id"] do
          success = true
        else
          success = false
        end
      end
    else
      success = false
    end

    if success do
      conn
    else
      conn
      |> put_flash(:info, "You have no rights to do it")
      |> redirect(to: brand_path(conn, :index))
    end
  end
end
