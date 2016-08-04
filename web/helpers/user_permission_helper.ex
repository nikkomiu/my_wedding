defmodule MyWedding.UserPermissionHelper do
  alias MyWedding.User

  def permission_string(num) do
    User.permissions()
    |> get_permission_by_num(num)
    |> permissions_to_string()
  end

  def permission_options() do
    User.permissions()
  end

  defp get_permission_by_num(permissions, num) do
    permissions
    |> Enum.filter(fn(x) ->
      x |> Tuple.to_list() |> List.last() == num
    end)
  end

  defp permissions_to_string(list) do
    list
    |> permissions_to_list()
    |> Enum.join(", ")
  end

  defp permissions_to_list(list) do
    list
    |> Enum.map(fn(x) ->
      x |> Tuple.to_list() |> List.first()
    end)
  end
end
