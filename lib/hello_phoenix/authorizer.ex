defmodule HelloPhoenix.Authorizer do
  def can_access?(%HelloPhoenix.User{id: user_id}, %{user_id: user_id}), do: true
  def can_access?(_, _), do: false
end
