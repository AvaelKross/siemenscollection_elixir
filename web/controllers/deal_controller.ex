defmodule SiemensCollection.DealController do
  use SiemensCollection.Web, :controller

  alias SiemensCollection.{Deal, PhoneEdition, User}

  plug Addict.Plugs.Authenticated when action in [:index, :new, :create]

  plug :scrub_params, "deal" when action in [:create, :update]
  plug :set_user
  plug :set_deal when action in [:show, :edit, :update, :delete]

  plug :check_rights when action in [:show, :edit, :update, :delete]

  def index(conn, _params) do
    user_id = conn.assigns.user.id
    query = Deal |> Deal.for_user(user_id) 
    query = from query, preload: [phone_edition: [phone: :brand]]

    deals = Repo.all(query)

    render(conn, "index.html", deals: deals)
  end

  def new(conn, _params) do
    hash = if conn.params["edition_id"] do
      %Deal{phone_edition_id: conn.params["edition_id"]}
    else
      %Deal{}
    end
    changeset = Deal.changeset(hash)
    phone_editions = Repo.all(PhoneEdition) |> Repo.preload([phone: :brand])
    render(conn, "new.html", phone_editions: phone_editions, changeset: changeset)
  end

  def create(conn, %{"deal" => deal_params}) do
    params = Map.merge(deal_params, %{"user_id" => Addict.Helper.current_user(conn).id})
    changeset = Deal.changeset(%Deal{}, params)

    case Repo.insert(changeset) do
      {:ok, deal} ->
        conn
        |> put_flash(:info, "Deal created successfully.")
        |> redirect(to: deal_path(conn, :show, deal.id))
      {:error, changeset} ->
        phone_editions = Repo.all(PhoneEdition) |> Repo.preload([phone: :brand])
        render(conn, "new.html", phone_editions: phone_editions, changeset: changeset)
    end
  end

  def show(conn, _params) do
    deal = conn.assigns.deal |> Repo.preload([phone_edition: [phone: :brand]])
    render(conn, "show.html", deal: deal)
  end

  def edit(conn, _params) do
    deal = conn.assigns.deal |> Repo.preload([phone_edition: [phone: :brand]])
    phone_editions = Repo.all(PhoneEdition) |> Repo.preload([phone: :brand])
    changeset = Deal.changeset(deal)
    render(conn, "edit.html", deal: deal, phone_editions: phone_editions, changeset: changeset)
  end

  def update(conn, %{"deal" => deal_params}) do
    deal = conn.assigns.deal |> Repo.preload([phone_edition: [phone: :brand]])
    changeset = Deal.changeset(deal, deal_params)

    case Repo.update(changeset) do
      {:ok, deal} ->
        conn
        |> put_flash(:info, "Deal updated successfully.")
        |> redirect(to: deal_path(conn, :show, deal))
      {:error, changeset} ->
        phone_editions = Repo.all(PhoneEdition) |> Repo.preload([phone: :brand])
        render(conn, "edit.html", deal: deal, phone_editions: phone_editions, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    deal = conn.assigns.deal

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(deal)

    conn
    |> put_flash(:info, "Deal deleted successfully.")
    |> redirect(to: deal_path(conn, :index))
  end

  defp set_user(conn, _) do
    user = Repo.get(User, Addict.Helper.current_user(conn).id)
    assign(conn, :user, user)
  end

  defp set_deal(conn, _) do
    deal = Repo.get!(Deal, conn.params["id"])
    assign(conn, :deal, deal)
  end

  def check_rights(conn, _opts) do
    if Addict.Helper.current_user(conn) != nil && Addict.Helper.current_user(conn).id == conn.assigns.deal.user_id do
      conn
    else
      conn
      |> put_flash(:info, "You have no rights to do it")
      |> redirect(to: brand_path(conn, :index))
    end
  end

end
