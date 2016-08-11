defmodule MyWedding.ViewHelper do
  require Logger

  def mtl_label(form, field) do
    Phoenix.HTML.Form.label(form, field, class: is_active(form, field))
  end

  def is_active(form, field) do
    if (Phoenix.HTML.Form.field_value(form, field)) do
      "active"
    end
  end

  def template_name(template) do
    template |> String.split(".") |> List.first()
  end

  def upload_path(filename, size) do
    split_path =
      filename
      |> String.split(".")

    final_path =
      split_path
      |> List.replace_at(0, Enum.join([List.first(split_path), size], "-"))
      |> Enum.join(".")

    upload_path(final_path)
  end

  def upload_path(filename) do
    "/uploads/#{filename}"
  end
end
