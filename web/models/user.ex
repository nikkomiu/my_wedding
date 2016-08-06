defmodule MyWedding.User do
  use MyWedding.Web, :model

  alias Ueberauth.Auth

  schema "users" do
    field :avatar, :string
    field :name, :string
    field :email, :string
    field :permission_level, :integer

    field :can_login, :boolean

    field :google_uid, :string

    timestamps()
  end

  def permissions() do
    %{
      none: 0, # Allow creating albums, and uploading photos
      uploader: 1, # Allow editing albums
      author: 2, # Allow creating/editing content
      manager: 3, # Allow deleting content
      admin: 5
    }
  end

  def is_authorized(user, level_requested) do
    if user do
      user.permission_level >= permissions[level_requested]
    else
      false
    end
  end

  def find_or_create(%Auth{provider: :google} = auth) do
    user =
      MyWedding.Repo.one(
        from u in MyWedding.User,
          where: u.google_uid == ^auth.uid
      )

    cond do
      user != nil && user.can_login == false ->
        {:error, "User is inactive"}
      user != nil ->
        {:ok, user}
      true ->
        %MyWedding.User{}
        |> changeset(user_info(auth))
        |> MyWedding.Repo.insert()
    end
  end

  defp user_info(auth) do
    %{google_uid: auth.uid, email: auth.info.email, name: auth.info.name, avatar: auth.info.image}
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:avatar, :name, :email, :google_uid])
    |> validate_required([:name, :email, :google_uid])
  end

  def admin_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:avatar, :name, :email, :permission_level, :can_login])
    |> validate_required([:name, :email, :permission_level])
  end
end
