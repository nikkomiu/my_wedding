defmodule MyWedding.ErrorViewTest do
  use MyWedding.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(MyWedding.ErrorView, "404.html", [])
      |> String.contains?("404")
  end

  test "render 500.html" do
    assert render_to_string(MyWedding.ErrorView, "500.html", [])
      |> String.contains?("500")
  end

  test "render any other" do
    assert render_to_string(MyWedding.ErrorView, "505.html", [])
      |> String.contains?("500")
  end
end
