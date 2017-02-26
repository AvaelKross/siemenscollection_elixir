# defmodule SiemensCollection.PhoneEditionControllerTest do
#   use SiemensCollection.ConnCase
#
#   alias SiemensCollection.PhoneEdition
#   @valid_attrs %{limited: true, name: "some content", notes: "some content", prototype: true}
#   @invalid_attrs %{}
#
#   test "lists all entries on index", %{conn: conn} do
#     conn = get conn, phone_edition_path(conn, :index)
#     assert html_response(conn, 200) =~ "Listing phone editions"
#   end
#
#   test "renders form for new resources", %{conn: conn} do
#     conn = get conn, phone_edition_path(conn, :new)
#     assert html_response(conn, 200) =~ "New phone edition"
#   end
#
#   test "creates resource and redirects when data is valid", %{conn: conn} do
#     conn = post conn, phone_edition_path(conn, :create), phone_edition: @valid_attrs
#     assert redirected_to(conn) == phone_edition_path(conn, :index)
#     assert Repo.get_by(PhoneEdition, @valid_attrs)
#   end
#
#   test "does not create resource and renders errors when data is invalid", %{conn: conn} do
#     conn = post conn, phone_edition_path(conn, :create), phone_edition: @invalid_attrs
#     assert html_response(conn, 200) =~ "New phone edition"
#   end
#
#   test "shows chosen resource", %{conn: conn} do
#     phone_edition = Repo.insert! %PhoneEdition{}
#     conn = get conn, phone_edition_path(conn, :show, phone_edition)
#     assert html_response(conn, 200) =~ "Show phone edition"
#   end
#
#   test "renders page not found when id is nonexistent", %{conn: conn} do
#     assert_error_sent 404, fn ->
#       get conn, phone_edition_path(conn, :show, -1)
#     end
#   end
#
#   test "renders form for editing chosen resource", %{conn: conn} do
#     phone_edition = Repo.insert! %PhoneEdition{}
#     conn = get conn, phone_edition_path(conn, :edit, phone_edition)
#     assert html_response(conn, 200) =~ "Edit phone edition"
#   end
#
#   test "updates chosen resource and redirects when data is valid", %{conn: conn} do
#     phone_edition = Repo.insert! %PhoneEdition{}
#     conn = put conn, phone_edition_path(conn, :update, phone_edition), phone_edition: @valid_attrs
#     assert redirected_to(conn) == phone_edition_path(conn, :show, phone_edition)
#     assert Repo.get_by(PhoneEdition, @valid_attrs)
#   end
#
#   test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
#     phone_edition = Repo.insert! %PhoneEdition{}
#     conn = put conn, phone_edition_path(conn, :update, phone_edition), phone_edition: @invalid_attrs
#     assert html_response(conn, 200) =~ "Edit phone edition"
#   end
#
#   test "deletes chosen resource", %{conn: conn} do
#     phone_edition = Repo.insert! %PhoneEdition{}
#     conn = delete conn, phone_edition_path(conn, :delete, phone_edition)
#     assert redirected_to(conn) == phone_edition_path(conn, :index)
#     refute Repo.get(PhoneEdition, phone_edition.id)
#   end
# end
