defmodule FutureCyborg.API.ListItemController do
  use FutureCyborg.Web, :controller
  alias FutureCyborg.ListItem

  import FutureCyborg.Router.Helpers, only: [api_list_item_path: 2, api_list_item_path: 3]

  def create(conn, %{"list_item" => list_item}) do
    changeset = ListItem.changeset(%ListItem{}, list_item)

    case Repo.insert(changeset) do
      {:ok, list_item} ->
        # Good stuff
        conn |> json %{list_item: api_list_item_path(FutureCyborg.Endpoint, :show, list_item)}
      {:error, changeset} ->
        #bad stuff
        conn |> json_bad_request changeset
    end
  end
  def create(conn, _) do
    conn |> put_status(:bad_request) |> json %{error: "Bad request"}
  end

  def show(conn, %{"id" => id}) do
    list_item = Repo.get(ListItem, id) |> Repo.preload([:shopping_list])
    case list_item do
      l when not is_nil(l) ->
        conn |> json l
      nil ->
        conn |> json_bad_request ""
    end
  end
  def show(conn, _), do: conn |> put_status(:bad_request) |> text ""

  def index(conn, _) do
    conn |> json %{status: :ok}
  end

  defp json_bad_request(conn, error) do
    conn |> put_status(:bad_request) |> json %{error: error}
  end
end
