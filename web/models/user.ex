defmodule WeddingWebsite.User do
  use WeddingWebsite.Web, :model

  alias Ueberauth.Auth

  schema "users" do
    field :avatar, :string
    field :name, :string
    field :email, :string

    field :google_uid, :string

    timestamps()
  end

  def find_or_create(%Auth{provider: :google} = auth) do
    user =
      WeddingWebsite.Repo.one(
        from u in WeddingWebsite.User,
          where: u.google_uid == ^auth.uid
      )

    if user do
      {:ok, user}
    else
      new_user =
        %WeddingWebsite.User{}
        |> changeset(user_info(auth))

      WeddingWebsite.Repo.insert(new_user)
    end
  end

  defp user_info(auth) do
    %{google_uid: auth.uid, email: auth.info.email, name: auth.info.name, avatar: auth.info.image}
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:avatar, :name, :email, :google_uid])
    |> validate_required([:name, :email])
  end
end
