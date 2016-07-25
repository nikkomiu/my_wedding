defmodule WeddingWebsite.ViewHelpers do

  require Logger

  def mtl_label(form, field) do
    Phoenix.HTML.Form.label(form, field, class: is_active(form, field))
  end

  def is_active(form, field) do
    if (Phoenix.HTML.Form.field_value(form, field)) do
      "active"
    end
  end

  def upload_path(filename) do
    "/uploads/#{filename}"
  end

  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end
end
