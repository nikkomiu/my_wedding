defmodule MyWedding.AlbumView do
  use MyWedding.Web, :view

  def render("upload_head.html", _) do
    {:safe, "<script src='https://www.google.com/recaptcha/api.js'></script>"}
  end

  def render("upload_js.html", %{skip_recaptcha: skip_recaptcha}) do
    if skip_recaptcha do
      {:safe, ""}
    else
      render MyWedding.SharedView, "_recaptcha.html"
    end
  end
end
