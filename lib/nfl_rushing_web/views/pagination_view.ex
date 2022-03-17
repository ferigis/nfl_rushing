defmodule NFL.RushingWeb.PaginationView do
  use NFL.RushingWeb, :view

  @doc false
  def render("index.json", %{view: view, page: %{entries: entries} = page}) do
    view
    |> apply(:render, ["index.json", [entries: entries]])
    |> Map.merge(%{
      meta: %{
        page: page.page_number,
        page_size: page.page_size,
        total_pages: page.total_pages,
        total_entries: page.total_entries
      }
    })
  end
end
