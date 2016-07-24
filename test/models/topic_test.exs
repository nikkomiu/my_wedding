defmodule WeddingWebsite.TopicTest do
  use WeddingWebsite.ModelCase

  alias WeddingWebsite.Topic

  @valid_attrs %{audience: 42, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Topic.changeset(%Topic{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Topic.changeset(%Topic{}, @invalid_attrs)
    refute changeset.valid?
  end
end
