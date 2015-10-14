defmodule FutureCyborg.User do
  use FutureCyborg.Web, :model
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :username, :string
    field :password, :string
    field :email, :string

    has_many :videos, FutureCyborg.Post
    timestamps
  end

  @required_fields ~w(username password email)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  before_insert :hash_password
  def hash_password(changeset) do
    password = Ecto.Changeset.get_field(changeset, :password)
    hash = hashpwsalt(password)
    put_change(changeset, :password, hash)
  end
end
