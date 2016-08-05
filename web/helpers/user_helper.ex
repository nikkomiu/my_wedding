defmodule MyWedding.UserHelper do
  defmacro __using__(_opts) do
    auth_functions =
      MyWedding.User.permissions
      |> Enum.map(fn (permission_tuple) ->
        # Get the permission name from the Tuple
        permission = tuple_keys(permission_tuple)

        # Generate the function
        gen_function(permission)
      end)

    # Import helpers and functions
    quote do
      import MyWedding.UserHelper
      import Plug.Conn

      unquote(auth_functions)
    end
  end

  defp gen_function(perm) do
    quote do
      def unquote(:"authorize_#{perm}")(conn, params) do
        unless is_authorized(conn, unquote(perm)) do
          has_unauthorized_fn =
            __info__(:functions) |>
            Enum.map(fn(tuple) -> tuple_keys(tuple) end)
            |> Enum.member?(:unauthorized)

          if has_unauthorized_fn do
            apply(__MODULE__, :unauthorized, [conn, params])
          else
            conn
            |> put_flash(:error, "You are not allowed to do that!")
            |> redirect(to: "/")
          end
          |> send_resp()
        end

        conn
      end
    end
  end

  def tuple_keys(tuple) do
    tuple
    |> Tuple.to_list()
    |> List.first()
  end

  def is_authorized(conn, auth_level) do
    current_user(conn)
    |> MyWedding.User.is_authorized(auth_level)
  end

  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def permission_string(num) do
    MyWedding.User.permissions()
    |> get_permission_by_num(num)
    |> permissions_to_string()
  end

  def permission_options() do
    MyWedding.User.permissions()
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
