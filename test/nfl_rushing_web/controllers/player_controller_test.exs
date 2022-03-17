defmodule NFL.RushingWeb.PlayerControllerTest do
  use NFL.RushingWeb.ConnCase

  import NFL.Rushing.PlayersFixtures

  setup do
    jack_sparrow = player_fixture(%{name: "Jack Sparrow", yards: 10})
    goku = player_fixture(%{name: "Goku", yards: 100})
    luke = player_fixture(%{name: "Luke Skywalker ", yards: 7})

    [jack_sparrow: jack_sparrow, goku: goku, luke: luke]
  end

  describe "GET /api/v1/players (json)" do
    test "ok: get all players", %{conn: conn} do
      conn = get(conn, Routes.player_path(conn, :index))
      resp = json_response(conn, 200)

      assert %{"page" => 1, "page_size" => 20, "total_entries" => 3, "total_pages" => 1} ==
               resp["meta"]

      assert [_, _, _] = resp["data"]
    end

    test "ok: filter", %{conn: conn, goku: goku} do
      conn = get(conn, Routes.player_path(conn, :index) <> "?name=goku")
      resp = json_response(conn, 200)

      assert %{"page" => 1, "page_size" => 20, "total_entries" => 1, "total_pages" => 1} ==
               resp["meta"]

      assert [
               %{
                 "id" => goku.id,
                 "attempts" => goku.attempts,
                 "attempts_per_game_avg" => goku.attempts_per_game_avg,
                 "first_downs" => goku.first_downs,
                 "first_downs_percentage" => goku.first_downs_percentage,
                 "fumbles" => goku.fumbles,
                 "is_longest_rush_touchdown" => goku.is_longest_rush_touchdown,
                 "longest_rush" => goku.longest_rush,
                 "name" => goku.name,
                 "plus_20_yards" => goku.plus_20_yards,
                 "plus_40_yards" => goku.plus_40_yards,
                 "position" => goku.position,
                 "team" => goku.team,
                 "touchdowns" => goku.touchdowns,
                 "yards" => goku.yards,
                 "yards_per_attempt_avg" => goku.yards_per_attempt_avg,
                 "yards_per_game" => goku.yards_per_game
               }
             ] == resp["data"]
    end

    test "ok: paginate", %{
      conn: conn,
      jack_sparrow: %{id: jack_id},
      goku: %{id: goku_id},
      luke: %{id: luke_id}
    } do
      conn =
        get(
          conn,
          Routes.player_path(conn, :index) <> "?page_size=2&page=1&sort_by=yards&order_by=desc"
        )

      resp = json_response(conn, 200)

      assert %{"page" => 1, "page_size" => 2, "total_entries" => 3, "total_pages" => 2} ==
               resp["meta"]

      assert [%{"id" => ^goku_id}, %{"id" => ^jack_id}] = resp["data"]

      conn =
        get(
          build_conn(),
          Routes.player_path(conn, :index) <> "?page_size=2&page=2&sort_by=yards&order_by=desc"
        )

      resp = json_response(conn, 200)

      assert %{"page" => 2, "page_size" => 2, "total_entries" => 3, "total_pages" => 2} ==
               resp["meta"]

      assert [%{"id" => ^luke_id}] = resp["data"]
    end

    test "error: wrong search params", %{conn: conn} do
      conn = get(conn, Routes.player_path(conn, :index) <> "?page_size=one")
      assert %{"page_size" => ["is invalid"]} == json_response(conn, 422)["errors"]
    end
  end

  describe "GET /api/v1/players (csv)" do
    setup %{conn: conn} do
      [conn: put_req_header(conn, "accept", "text/csv")]
    end

    test "ok: get all players", %{conn: conn} do
      conn = get(conn, Routes.player_path(conn, :index))
      assert conn |> response(200) |> is_binary()
    end
  end
end
