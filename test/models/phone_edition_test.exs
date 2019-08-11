defmodule SiemensCollection.PhoneEditionTest do
  use SiemensCollection.ModelCase

  alias PhonesCollectionWeb.PhoneEdition

  @valid_attrs %{limited: true, name: "some content", notes: "some content", prototype: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PhoneEdition.changeset(%PhoneEdition{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PhoneEdition.changeset(%PhoneEdition{}, @invalid_attrs)
    refute changeset.valid?
  end
end
