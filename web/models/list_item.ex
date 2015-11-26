defmodule FutureCyborg.ListItem do
  use FutureCyborg.Web, :model

  schema "list_items" do
    field :name, :string
    belongs_to :shopping_list, FutureCyborg.ShoppingList

    timestamps
  end

  @required_fields ~w(name shopping_list_id)
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
end
