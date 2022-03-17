defmodule NFL.RushingWeb.PageController do
  use NFL.RushingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
