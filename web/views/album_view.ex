defmodule MyWedding.AlbumView do
  use MyWedding.Web, :view

  def render("show_js.html", _) do
    {:safe, "<script>$('html').css('background-color', '#292929');</script>"}
  end
end
