defmodule SiemensCollection.ProfileController do
  use SiemensCollection.Web, :controller

  alias SiemensCollection.User

  plug Addict.Plugs.Authenticated when action in [:edit, :update]

  # def show(conn, %{"user_id" => id}) do
  #   user = Repo.get!(User, id)
  #   render(conn, "show.html", user: user)
  # end

  def edit(conn, _) do
    user = Repo.get!(User, Addict.Helper.current_user(conn).id)
    changeset = User.changeset(user)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user = Repo.get!(User, Addict.Helper.current_user(conn).id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Profile updated successfully.")
        |> redirect(to: profile_path(conn, :edit))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
