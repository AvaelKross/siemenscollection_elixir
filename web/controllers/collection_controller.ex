defmodule SiemensCollection.CollectionController do
  use SiemensCollection.Web, :controller

  alias SiemensCollection.User

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end
end
