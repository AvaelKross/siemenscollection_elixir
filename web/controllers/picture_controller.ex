defmodule SiemensCollection.PictureController do
  use SiemensCollection.Web, :controller

  alias SiemensCollection.PhoneEdition
  alias SiemensCollection.Picture
  alias SiemensCollection.Image

  plug :scrub_params, "images" when action in [:create]

  plug SiemensCollection.Plugs.CheckAdminRights when action in [:new, :create, :delete]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"images" => images_params}) do
    if images_params["images_from_pc"] != nil do
      Enum.each images_params["images_from_pc"], fn n ->
        if n != nil && n != "" do
          changeset = Picture.changeset(%Picture{}, %{phone_edition_id: conn.params["edition_id"]})
          {:ok, picture} = Repo.insert(changeset)
          changeset = Picture.changeset(picture, %{image: n})
          {:ok, _} = Repo.update(changeset)
        end
      end
    end
    if images_params["images_from_link"] != nil do
      Enum.each images_params["images_from_link"], fn n ->
        if n != nil && n != "" do
          changeset = Picture.changeset(%Picture{}, %{phone_edition_id: conn.params["edition_id"]})
          {:ok, picture} = Repo.insert(changeset)
          changeset = Picture.changeset(picture, %{image: n})
          {:ok, _} = Repo.update(changeset)
        end
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
end
