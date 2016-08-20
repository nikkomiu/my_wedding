defmodule MyWedding.ErrorView do
  use MyWedding.Web, :view

  def render("401.json", _) do
    %{message: "You are not authorized to do that!"}
  end

  def render("422.json", _assigns) do
    %{message: "Could not process request"}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
