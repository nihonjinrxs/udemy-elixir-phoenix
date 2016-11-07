defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  # Only called once the first time the plug is used
  def init(_params) do
  end

  # Note, _params here is the return from init above.
  # Called every time the module plug is called in a request.
  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        # User ID exists, and user has the User struct
        assign(conn, :user, user)
      true ->
        # Default operation (like "else")
        assign(conn, :user, nil)
    end
  end
end
