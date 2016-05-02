defmodule SiemensCollection.PhoneControllerTest do
  use SiemensCollection.ConnCase

  alias SiemensCollection.Phone
  @valid_attrs %{battery: "some content", features: "some content", name: "some content", network: "some content", notes: "some content", photo_url: "some content", release: "some content", size: "some content", weight: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, phone_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing phones"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, phone_path(conn, :new)
    assert html_response(conn, 200) =~ "New phone"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, phone_path(conn, :create), phone: @valid_attrs
    assert redirected_to(conn) == phone_path(conn, :index)
    assert Repo.get_by(Phone, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, phone_path(conn, :create), phone: @invalid_attrs
    assert html_response(conn, 200) =~ "New phone"
  end

  test "shows chosen resource", %{conn: conn} do
    phone = Repo.insert! %Phone{}
    conn = get conn, phone_path(conn, :show, phone)
    assert html_response(conn, 200) =~ "Show phone"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, phone_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    phone = Repo.insert! %Phone{}
    conn = get conn, phone_path(conn, :edit, phone)
    assert html_response(conn, 200) =~ "Edit phone"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    phone = Repo.insert! %Phone{}
    conn = put conn, phone_path(conn, :update, phone), phone: @valid_attrs
    assert redirected_to(conn) == phone_path(conn, :show, phone)
    assert Repo.get_by(Phone, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    phone = Repo.insert! %Phone{}
    conn = put conn, phone_path(conn, :update, phone), phone: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit phone"
  end

  test "deletes chosen resource", %{conn: conn} do
    phone = Repo.insert! %Phone{}
    conn = delete conn, phone_path(conn, :delete, phone)
    assert redirected_to(conn) == phone_path(conn, :index)
    refute Repo.get(Phone, phone.id)
  end
end
