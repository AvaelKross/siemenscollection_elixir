defmodule SiemensCollection.SeriesTest do
  use SiemensCollection.ModelCase

  alias PhonesCollectionWeb.Series

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Series.changeset(%Series{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Series.changeset(%Series{}, @invalid_attrs)
    refute changeset.valid?
  end
end
