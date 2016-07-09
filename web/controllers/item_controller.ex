defmodule SiemensCollection.ItemController do
  use SiemensCollection.Web, :controller

  alias SiemensCollection.{Item, PhoneEdition, User}

  plug Addict.Plugs.Authenticated when action in [:new, :create]

  plug :scrub_params, "item" when action in [:create, :update]
  plug :set_user
  plug :set_item when action in [:show, :edit, :update, :delete]

  plug :check_rights when action in [:edit, :update, :delete]

  def index(conn, _params) do
    user_id = conn.assigns.user.id
    query = Item |> Item.for_user(user_id)
    items = Repo.all(query) |> Repo.preload([phone_edition: [phone: :brand]])

    render(conn, "index.html", items: items)
  end

  def new(conn, _params) do
    hash = if conn.params["edition_id"] do
      %Item{phone_edition_id: conn.params["edition_id"]}
    else
      %Item{}
    end
    changeset = Item.changeset(hash)
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
        |> redirect(to: collections_item_path(conn, :index, conn.assigns.user.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = conn.assigns.item |> Repo.preload([:pictures, phone_edition: [:pictures, phone: :brand]])
    render(conn, "show.html", item: item)
  end

  def edit(conn, %{"id" => id}) do
    item = conn.assigns.item |> Repo.preload([:pictures, phone_edition: [:pictures, phone: :brand]])
    phone_editions = Repo.all(PhoneEdition) |> Repo.preload([phone: :brand])
    changeset = Item.changeset(item)
    render(conn, "edit.html", item: item, phone_editions: phone_editions, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = conn.assigns.item
    changeset = Item.changeset(item, item_params)

    case Repo.update(changeset) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: collections_item_path(conn, :show, conn.assigns.user.id, item))
      {:error, changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = conn.assigns.item

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: collections_item_path(conn, :index, conn.assigns.user.id))
  end

  defp set_user(conn, _) do
    user = if conn.params["user_id"] do
             Repo.get(User, conn.params["user_id"])
           else
             Repo.get(User, Addict.Helper.current_user(conn).id)
           end
    assign(conn, :user, user)
  end

  defp set_item(conn, _) do
    item = Repo.get!(Item, conn.params["id"])
    assign(conn, :item, item)
  end

  def check_rights(conn, _opts) do
    if Addict.Helper.current_user(conn).id == conn.assigns.item.user_id do
      conn
    else
      conn
      |> put_flash(:info, "You have no rights to do it")
      |> redirect(to: brand_path(conn, :index))
    end
  end

end
