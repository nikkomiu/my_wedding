defmodule WeddingWebsite.PostTest do
  use WeddingWebsite.ModelCase

  alias WeddingWebsite.Post

  @valid_attrs %{body: "some content", is_active: true, order: 42, title: "some content"}
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
