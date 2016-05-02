defmodule SiemensCollection.PageController do
  use SiemensCollection.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
