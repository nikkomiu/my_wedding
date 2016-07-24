defmodule WeddingWebsite.PhotoTest do
  use WeddingWebsite.ModelCase

  alias WeddingWebsite.Photo

  @valid_attrs %{path: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Photo.changeset(%Photo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Photo.changeset(%Photo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
