defmodule MyWedding.UserTest do
  use MyWedding.ModelCase

  alias MyWedding.User

  @valid_attrs %{email: "some content", name: "some content", google_uid: "2342351"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
