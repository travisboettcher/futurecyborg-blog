defmodule FutureCyborg.Post do
  use FutureCyborg.Web, :model

  schema "posts" do
    field :title, :string
    field :content, :string
    field :likes, :integer
    field :views, :integer
    belongs_to :user, FutureCyborg.User

    timestamps
  end

  @required_fields ~w(title content user_id)
  @optional_fields ~w(likes views)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
