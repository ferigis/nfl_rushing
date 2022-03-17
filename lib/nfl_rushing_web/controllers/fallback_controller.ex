defmodule NFL.RushingWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use NFL.RushingWeb, :controller

  @doc false
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    unprocessable_entity(conn, changeset)
  end

  ## Private Functions

  defp unprocessable_entity(conn, changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(NFL.RushingWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end
end
