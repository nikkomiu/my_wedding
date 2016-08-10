defmodule MyWedding.PostView do
  use MyWedding.Web, :view

  def render("new_js.html", _) do
    render_simplemde()
  end

  def render("edit_js.html", _) do
    render_simplemde()
  end

  defp render_simplemde() do
    render(MyWedding.SharedView, "_simplemde.html", element: "post_body")
  end
end
