defmodule MyWedding.AlbumView do
  use MyWedding.Web, :view

  def render("upload_head.html", _) do
    {:safe, "<script src='https://www.google.com/recaptcha/api.js'></script>"}
  end
end
