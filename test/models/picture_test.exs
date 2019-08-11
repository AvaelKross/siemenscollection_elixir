defmodule SiemensCollection.PictureTest do
  use SiemensCollection.ModelCase

  alias PhonesCollectionWeb.Picture

  @valid_attrs %{url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Picture.changeset(%Picture{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Picture.changeset(%Picture{}, @invalid_attrs)
    refute changeset.valid?
  end
end
