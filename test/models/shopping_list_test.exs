defmodule FutureCyborg.ShoppingListTest do
  use FutureCyborg.ModelCase

  alias FutureCyborg.ShoppingList

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ShoppingList.changeset(%ShoppingList{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ShoppingList.changeset(%ShoppingList{}, @invalid_attrs)
    refute changeset.valid?
  end
end
