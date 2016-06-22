defmodule SiemensCollection.ItemController do
  use SiemensCollection.Web, :controller

  alias SiemensCollection.Item

  alias SiemensCollection.Phone
  alias SiemensCollection.PhoneEdition
  alias SiemensCollection.Brand
  alias SiemensCollection.User

  plug Addict.Plugs.Authenticated when action in [:new, :create, :edit, :update, :delete]
  plug :check_rights when action in [:edit, :update, :delete]

  plug :scrub_params, "item" when action in [:create, :update]
  plug :set_user

  def index(conn, _params) do
    items = Repo.all(Item) |> Repo.preload([phone_edition: [phone: :brand]])
    render(conn, "index.html", items: items)
  end

  def new(conn, _params) do
    changeset = Item.changeset(%Item{})
    phone_editions = Repo.all(PhoneEdition) |> Repo.preload([phone: :brand])
    render(conn, "new.html", phone_editions: phone_editions, changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    params = Map.merge(item_params, %{"user_id" => Addict.Helper.current_user(conn).id})
    changeset = Item.changeset(%Item{}, params)

    case Repo.insert(changeset) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: short_item_path(conn, :index, conn.assigns.user.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Repo.get!(Item, id) |> Repo.preload([phone_edition: [phone: :brand]])
    render(conn, "show.html", item: item)
  end

  def edit(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    phone_editions = Repo.all(PhoneEdition) |> Repo.preload([phone: :brand])
    changeset = Item.changeset(item)
    render(conn, "edit.html", item: item, phone_editions: phone_editions, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Repo.get!(Item, id)
    changeset = Item.changeset(item, item_params)

    case Repo.update(changeset) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: short_item_path(conn, :show, conn.assigns.user.id, item))
      {:error, changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: short_item_path(conn, :index, conn.assigns.user.id))
  end

  defp set_user(conn, _) do
    if conn.params["user_id"] do
      user = Repo.get(User, conn.params["user_id"])
      assign(conn, :user, user)
    else
      conn
    end
  end

  defp check_rights(conn, _) do
    if Addict.Helper.current_user(conn) && Integer.to_string(Addict.Helper.current_user(conn).id) != conn.params["user_id"] do
      conn
      |> put_flash(:info, "You have no rights to do it")
      |> redirect(to: short_brand_path(conn, :index))
    else
      conn
    end
  end
end
