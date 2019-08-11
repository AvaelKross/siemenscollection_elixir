defmodule SiemensCollection.PhoneTest do
  use SiemensCollection.ModelCase, async: true

  alias PhonesCollectionWeb.Phone

  @valid_attrs %{battery: "some content", features: "some content", name: "some content", network: "some content", notes: "some content", photo_url: "some content", release: "some content", size: "some content", weight: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Phone.changeset(%Phone{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Phone.changeset(%Phone{}, @invalid_attrs)
    refute changeset.valid?
  end
end
