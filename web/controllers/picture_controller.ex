defmodule SiemensCollection.PictureController do
  use SiemensCollection.Web, :controller

  alias SiemensCollection.{Picture}

  plug :scrub_params, "images" when action in [:create]
  plug :redirect_path when action in [:create, :delete, :rotate, :set_cover]

  plug Addict.Plugs.Authenticated when action in [:new, :create, :delete, :rotate, :set_cover]
  plug :check_rights when action in [:new, :create, :delete, :rotate, :set_cover]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"images" => images}) do
    picture_hash = if conn.params["edition_id"] != nil do
                     %{phone_edition_id: conn.params["edition_id"]}
                   else
                     %{item_id: conn.params["item_id"]}
                   end

    images
    |> Stream.map(fn image -> Task.async(fn -> Picture.create_with_image(picture_hash, image) end) end)
    |> Enum.map(&(Task.await(&1, 500000)))

    conn
    |> put_flash(:info, "Images uploaded successfully.")
    |> redirect(to: conn.assigns.redirect_path)
  end

  def delete(conn, %{"id" => id}) do
    picture = Repo.get!(Picture, id)

    Repo.delete!(picture)

    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: conn.assigns.redirect_path)
  end

  def rotate(conn, %{"id" => id, "direction" => direction}) do
    picture = Repo.get!(Picture, id)

    # Refactor this! Move rotating code somewhere.

    image = picture
    |> Picture.get_url(:original)
    |> Arc.File.new

    transformation = case direction do
      "right" -> "-rotate 90"
      "left" -> "-rotate -90"
      _ -> "-rotate 90"
    end

    rotated_image = Arc.Transformations.Convert.apply(:convert,
                                                      image,
                                                      transformation)

    filename = rotated_image.file_name |> String.split("?") |> Enum.at(0)

    prepared_image_hash = %{filename: filename, path: rotated_image.path}

    changeset = Picture.changeset(picture, %{image: prepared_image_hash})
    {:ok, _} = Repo.update(changeset)

    conn
    |> redirect(to: conn.assigns.redirect_path)
  end

  def set_cover(conn, params) do
    item_id = params["item_id"]
    edition_id = params["edition_id"]
    id = params["id"]

    changeset = if edition_id != nil do
      Repo.get!(SiemensCollection.PhoneEdition, edition_id)
      |> SiemensCollection.PhoneEdition.changeset(%{cover_id: id})
    else
      Repo.get!(SiemensCollection.Item, item_id)
      |> SiemensCollection.Item.changeset(%{cover_id: id})
    end
    {:ok, _imageable} = Repo.update(changeset)
    conn
    |> put_flash(:info, "Cover updated successfully.")
    |> redirect(to: conn.assigns.redirect_path)
  end

  defp redirect_path(conn, _) do
    path = if conn.params["edition_id"] != nil do
             catalog_phone_edition_path(conn, :edit, conn.params["brand_id"],
                                                     conn.params["phone_id"],
                                                     conn.params["edition_id"])
           else
             collections_item_path(conn, :edit, conn.params["user_id"],
                                                conn.params["item_id"])
           end
    assign(conn, :redirect_path, path)
  end

  defp check_rights(conn, _) do
    if conn.params["edition_id"] != nil do
      if SiemensCollection.Plugs.CheckAdminRights.can_edit(conn), do: conn, else: redirect_no_rights(conn)
    else
      item = Repo.get!(SiemensCollection.Item, conn.params["item_id"])
      if Addict.Helper.current_user(conn).id == item.user_id do
        conn
      else
        redirect_no_rights(conn)
      end
    end
  end

  defp redirect_no_rights(conn) do
    conn
      |> put_flash(:info, "You have no rights to do it")
      |> redirect(to: brand_path(conn, :index))
  end

end
