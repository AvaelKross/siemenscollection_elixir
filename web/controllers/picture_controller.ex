defmodule SiemensCollection.PictureController do
  use SiemensCollection.Web, :controller

  alias SiemensCollection.{Picture}

  plug :scrub_params, "images" when action in [:create]
  plug :redirect_path when action in [:create, :delete, :rotate]

  plug Addict.Plugs.Authenticated when action in [:new, :create, :delete, :rotate]
  plug :check_rights when action in [:new, :create, :delete, :rotate]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"images" => images}) do
    picture_hash = if conn.params["edition_id"] != nil do
                     %{phone_edition_id: conn.params["edition_id"]}
                   else
                     %{item_id: conn.params["item_id"]}
                   end

    Enum.each images, fn n ->
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
