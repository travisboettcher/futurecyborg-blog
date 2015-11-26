defmodule FutureCyborg.ShoppingList do
  use FutureCyborg.Web, :model

  schema "shopping_lists" do
    field :name, :string
    belongs_to :user, FutureCyborg.User

    has_many :list_items, FutureCyborg.ListItem
    timestamps
  end

  @required_fields ~w(name)
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

  defimpl Poison.Encoder, for: Any do
    def encode(%{__struct__: _} = struct, options) do
      map = struct
            |> Map.from_struct
            |> sanitize_map
      Poison.Encoder.Map.encode(map, options)
    end

    defp sanitize_map(map) do
      Map.drop(map, [:__meta__, :__struct__])
    end
  end
end
