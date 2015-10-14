defmodule FutureCyborg.PostTest do
  use FutureCyborg.ModelCase

  alias FutureCyborg.Post

  @valid_attrs %{content: "some content", likes: 42, title: "some content", views: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
