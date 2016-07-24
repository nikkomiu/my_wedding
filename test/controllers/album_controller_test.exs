defmodule WeddingWebsite.AlbumControllerTest do
  use WeddingWebsite.ConnCase

  alias WeddingWebsite.Album
  @valid_attrs %{description: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, album_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing albums"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, album_path(conn, :new)
    assert html_response(conn, 200) =~ "New album"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, album_path(conn, :create), album: @valid_attrs
    assert redirected_to(conn) == album_path(conn, :index)
    assert Repo.get_by(Album, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, album_path(conn, :create), album: @invalid_attrs
    assert html_response(conn, 200) =~ "New album"
  end

  test "shows chosen resource", %{conn: conn} do
    album = Repo.insert! %Album{}
    conn = get conn, album_path(conn, :show, album)
    assert html_response(conn, 200) =~ "Show album"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, album_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    album = Repo.insert! %Album{}
    conn = get conn, album_path(conn, :edit, album)
    assert html_response(conn, 200) =~ "Edit album"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    album = Repo.insert! %Album{}
    conn = put conn, album_path(conn, :update, album), album: @valid_attrs
    assert redirected_to(conn) == album_path(conn, :show, album)
    assert Repo.get_by(Album, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    album = Repo.insert! %Album{}
    conn = put conn, album_path(conn, :update, album), album: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit album"
  end

  test "deletes chosen resource", %{conn: conn} do
    album = Repo.insert! %Album{}
    conn = delete conn, album_path(conn, :delete, album)
    assert redirected_to(conn) == album_path(conn, :index)
    refute Repo.get(Album, album.id)
  end
end
