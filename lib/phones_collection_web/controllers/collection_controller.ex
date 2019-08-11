defmodule PhonesCollectionWeb.CollectionController do
  use SiemensCollection.Web, :controller

  alias PhonesCollectionWeb.User

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end
end
