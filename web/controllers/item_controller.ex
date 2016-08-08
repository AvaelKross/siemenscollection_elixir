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
    query = Item |> Item.for_user(user_id) |> Item.pictures_count
    query = from query, preload: [:pictures, :cover, phone_edition: [:pictures, :cover, phone: :brand]]

    items = Repo.all(query)

    render(conn, "index.html", items: items)
  end

  def new(conn, _params) do
    hash = cond do
      conn.params["edition_id"] ->
        %Item{phone_edition_id: conn.params["edition_id"]}
      conn.params["deal_id"] ->
        deal = Repo.get!(SiemensCollection.Deal, conn.params["deal_id"])
        %Item{deal_id: deal.id, phone_edition_id: deal.phone_edition_id}
      true ->
        %Item{}
    end
    changeset = Item.changeset(hash)
    phone_editions = preload_editions
    render(conn, "new.html", phone_editions: phone_editions, changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    params = Map.merge(item_params, %{"user_id" => Addict.Helper.current_user(conn).id})
    changeset = Item.changeset(%Item{}, params)

    case Repo.insert(changeset) do
      {:ok, item} ->
        redirect_path = if conn.params["save_and_upload"] != nil do
          collections_picture_path(conn, :new, conn.assigns.user.id, item.id)
        else
          collections_item_path(conn, :show, conn.assigns.user.id, item.id)
        end
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: redirect_path)
      {:error, changeset} ->
        phone_editions = preload_editions
        render(conn, "new.html", phone_editions: phone_editions, changeset: changeset)
    end
  end

  def show(conn, _params) do
    item = conn.assigns.item |> Repo.preload([:pictures, :cover, phone_edition: [:pictures, :cover, phone: :brand]])
    render(conn, "show.html", item: item)
  end

  def edit(conn, _params) do
    item = conn.assigns.item |> Repo.preload([:pictures, phone_edition: [:pictures, phone: :brand]])
    phone_editions = preload_editions
    changeset = Item.changeset(item)
    render(conn, "edit.html", item: item, phone_editions: phone_editions, changeset: changeset)
  end

  def update(conn, %{"item" => item_params}) do
    item = conn.assigns.item
    changeset = Item.changeset(item, item_params)

    case Repo.update(changeset) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: collections_item_path(conn, :show, conn.assigns.user.id, item))
      {:error, changeset} ->
        phone_editions = preload_editions
        render(conn, "edit.html", item: item, phone_editions: phone_editions, changeset: changeset)
    end
  end

  def delete(conn, _params) do
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
    if Addict.Helper.current_user(conn) != nil && Addict.Helper.current_user(conn).id == conn.assigns.item.user_id do
      conn
    else
      conn
      |> put_flash(:info, "You have no rights to do it")
      |> redirect(to: brand_path(conn, :index))
    end
  end

  defp preload_editions do
    Repo.all(PhoneEdition)
    |> Repo.preload([phone: :brand])
    |> Enum.sort_by(&("#{SiemensCollection.PhoneEditionView.full_phone_name(&1)}"))
  end

end
