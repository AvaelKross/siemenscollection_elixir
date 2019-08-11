defmodule SiemensCollection.DealTest do
  use SiemensCollection.ModelCase

  alias PhonesCollectionWeb.Deal

  @valid_attrs %{contact_email: "some content", contact_name: "some content", contact_phone: "some content", link: "some content", notes: "some content", phone_edition_id: 42, price: "some content", status: "some content", user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Deal.changeset(%Deal{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Deal.changeset(%Deal{}, @invalid_attrs)
    refute changeset.valid?
  end
end
