defmodule NFL.RushingWeb.PlayerController do
  use NFL.RushingWeb, :controller
  use Params

  alias NFL.Rushing.Players

  action_fallback(NFL.RushingWeb.FallbackController)

  ## filters

  defparams(
    index_filter(%{
      name: :string,
      sort_by: :string,
      order_by: :string,
      page: :integer,
      page_size: :integer
    })
  )

  ## API

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, params) do
    changeset = index_filter(params)

    if changeset.valid? do
      page = changeset |> Params.to_map() |> Players.paginate_players()
      render_index(conn, page)
    else
      {:error, changeset}
    end
  end

  ## Private function

  defp render_index(conn, page) do
    # here we negociate the proper format according to the accept header sent
    # by the client. We render Json by default.

    case List.keyfind(conn.req_headers, "accept", 0) do
      {"accept", "text/csv"} ->
        conn
        |> put_resp_content_type("text/csv")
        |> put_resp_header("content-disposition", "attachment; filename=players.csv")
        |> render("index.csv", entries: page.entries)

      _ ->
        conn
        |> put_view(NFL.RushingWeb.PaginationView)
        |> render("index.json", page: page, view: NFL.RushingWeb.PlayerView)
    end
  end
end
