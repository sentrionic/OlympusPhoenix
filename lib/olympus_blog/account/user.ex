defmodule OlympusBlog.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :bio, :string
    field :image, :string

    field :following, :boolean, virtual: true

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_required([:email, :username, :password])
    |> validate_email()
    |> validate_username()
    |> put_password_hash()
    |> put_avatar()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, OlympusBlog.Repo)
    |> unique_constraint(:email)
  end

  defp validate_username(changeset) do
    changeset
    |> validate_length(:username, min: 3, max: 30)
    |> validate_format(:username, ~r/^[a-zA-Z0-9_.-]*$/,
      message: "Please use letters and numbers without space(only characters allowed _ . -)"
    )
    |> unique_constraint(:username)
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :bio])
    |> validate_required([:email, :username])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> change_avatar(attrs, user.id)
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end

  defp put_avatar(changeset) do
    case get_change(changeset, :email) do
      nil ->
        changeset

      email ->
        put_change(
          changeset,
          :image,
          "https://gravatar.com/avatar/#{generate_avatar(email)}?d=identicon"
        )
    end
  end

  defp change_avatar(changeset, attrs, user_id) do
    case attrs["image"] do
      nil ->
        changeset

      image ->
        put_change(
          changeset,
          :image,
          upload_image(image, user_id)
        )
    end
  end

  defp upload_image(image, user_id) do
    directory = "phoenix/users/#{user_id}"
    {:ok, image_binary} = File.read(image.path)
    bucket_name = Application.fetch_env!(:ex_aws, :bucket)
    region = Application.fetch_env!(:ex_aws, :region)
    key = "files/#{directory}/avatar.jpg"
    opts = [content_type: "image/jpg"]

    ExAws.S3.put_object(bucket_name, key, image_binary, opts)
    |> ExAws.request!()

    "https://#{bucket_name}.s3.#{region}.amazonaws.com/#{key}"
  end

  defp generate_avatar(email) do
    :crypto.hash(:md5, email)
    |> Base.encode16()
  end
end
