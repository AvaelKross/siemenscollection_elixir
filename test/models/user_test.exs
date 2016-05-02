defmodule SiemensCollection.UserTest do
  use SiemensCollection.ModelCase

  alias SiemensCollection.User

  @valid_attrs %{email: "some content", encrypted_password: "some content", location: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
