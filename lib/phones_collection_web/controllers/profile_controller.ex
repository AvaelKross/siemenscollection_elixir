defmodule PhonesCollectionWeb.ProfileController do
  use SiemensCollection.Web, :controller

  alias PhonesCollectionWeb.User

  # plug Addict.Plugs.Authenticated when action in [:edit, :update]
  plug PhonesCollectionWeb.Plugs.CheckAdminRights when action in [:delete]

  # def show(conn, %{"user_id" => id}) do
  #   user = Repo.get!(User, id)
  #   render(conn, "show.html", user: user)
  # end

  def edit(conn, _) do
    user = Repo.get!(User, Addict.Helper.current_user(conn).id)
    changeset = User.changeset(user)
    render(conn, "edit.html", changeset: changeset)
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.collections_collection_path(conn, :index))
  end

  def update(conn, %{"user" => user_params}) do
    user = Repo.get!(User, Addict.Helper.current_user(conn).id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Profile updated successfully.")
        |> redirect(to: Routes.collections_item_path(conn, :index, user.id))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
