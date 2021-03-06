defmodule SiemensCollection.ItemTest do
  use SiemensCollection.ModelCase

  alias SiemensCollection.Item

  @valid_attrs %{calls_time: "some content", condition: 42, imei: "some content", made_in: "some content", notes: "some content", released: "some content", selling: true, set: "some content", sw: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Item.changeset(%Item{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Item.changeset(%Item{}, @invalid_attrs)
    refute changeset.valid?
  end
end
