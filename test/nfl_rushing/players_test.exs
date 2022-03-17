defmodule NFL.Rushing.PlayersTest do
  use NFL.Rushing.DataCase

  alias NFL.Rushing.Players
  alias NFL.Rushing.Players.Player
  alias Scrivener.Page

  import NFL.Rushing.PlayersFixtures

  @player_attrs %{
    name: "Jack Sparrow",
    team: "TBP",
    position: "RB",
    attempts_per_game_avg: 2.1,
    attempts: 2,
    yards: 7,
    yards_per_attempt_avg: 3.5,
    yards_per_game: 7,
    touchdowns: 0,
    longest_rush: 7,
    is_longest_rush_touchdown: true,
    first_downs: 0,
    first_downs_percentage: 0.4,
    plus_20_yards: 0,
    plus_40_yards: 0,
    fumbles: 0
  }

  describe "create_player/1" do
    test "ok: creates a player" do
      assert {:ok, %Player{} = player} = Players.create_player(@player_attrs)

      assert player.id
      assert player.name == @player_attrs.name
      assert player.team == @player_attrs.team
      assert player.position == @player_attrs.position
      assert player.attempts_per_game_avg == @player_attrs.attempts_per_game_avg
      assert player.attempts == @player_attrs.attempts
      assert player.yards == @player_attrs.yards
      assert player.yards_per_attempt_avg == @player_attrs.yards_per_attempt_avg
      assert player.yards_per_game == @player_attrs.yards_per_game
      assert player.touchdowns == @player_attrs.touchdowns
      assert player.longest_rush == @player_attrs.longest_rush
      assert player.is_longest_rush_touchdown == @player_attrs.is_longest_rush_touchdown
      assert player.first_downs == @player_attrs.first_downs
      assert player.first_downs_percentage == @player_attrs.first_downs_percentage
      assert player.plus_20_yards == @player_attrs.plus_20_yards
      assert player.plus_40_yards == @player_attrs.plus_40_yards
      assert player.fumbles == @player_attrs.fumbles
    end

    test "error: required fields" do
      for field <- ~w(name yards first_downs longest_rush)a do
        attrs = Map.delete(@player_attrs, field)
        assert {:error, cs} = Players.create_player(attrs)
        assert errors_on(cs) == %{"#{field}": ["can't be blank"]}
      end
    end
  end

  describe "list_players/1" do
    setup do
      jack_sparrow =
        player_fixture(%{name: "Jack Sparrow", yards: 10, longest_rush: 2, touchdowns: 1})

      goku = player_fixture(%{name: "Goku", yards: 100, longest_rush: 3, touchdowns: 15})
      luke = player_fixture(%{name: "Luke Skywalker ", yards: 7, longest_rush: 4, touchdowns: 2})

      [jack_sparrow: jack_sparrow, goku: goku, luke: luke]
    end

    test "ok: returns all the players" do
      assert [_, _, _] = Players.list_players()
    end

    test "ok: filter by name", %{goku: goku} do
      assert [_, _, _] = Players.list_players(%{name: "k"})
      assert [goku] == Players.list_players(%{name: "gok"})
      assert [goku] == Players.list_players(%{name: "GoKU"})
      assert [] == Players.list_players(%{name: "yoda"})
    end

    test "ok: order by yards", %{jack_sparrow: jack, goku: goku, luke: luke} do
      assert [luke, jack, goku] == Players.list_players(%{sort_by: "yards"})
      assert [luke, jack, goku] == Players.list_players(%{sort_by: "yards", order_by: "asc"})
      assert [goku, jack, luke] == Players.list_players(%{sort_by: "yards", order_by: "desc"})
      assert [luke, jack, goku] == Players.list_players(%{sort_by: "yards", order_by: "wrong"})
    end

    test "ok: order by longest_rush", %{jack_sparrow: jack, goku: goku, luke: luke} do
      assert [jack, goku, luke] == Players.list_players(%{sort_by: "longest_rush"})

      assert [jack, goku, luke] ==
               Players.list_players(%{sort_by: "longest_rush", order_by: "asc"})

      assert [luke, goku, jack] ==
               Players.list_players(%{sort_by: "longest_rush", order_by: "desc"})

      assert [jack, goku, luke] ==
               Players.list_players(%{sort_by: "longest_rush", order_by: "wrong"})
    end

    test "ok: order by touchdowns", %{jack_sparrow: jack, goku: goku, luke: luke} do
      assert [jack, luke, goku] == Players.list_players(%{sort_by: "touchdowns"})
      assert [jack, luke, goku] == Players.list_players(%{sort_by: "touchdowns", order_by: "asc"})

      assert [goku, luke, jack] ==
               Players.list_players(%{sort_by: "touchdowns", order_by: "desc"})

      assert [jack, luke, goku] ==
               Players.list_players(%{sort_by: "touchdowns", order_by: "wrong"})
    end
  end

  describe "paginate_players/1" do
    setup do
      jack_sparrow =
        player_fixture(%{name: "Jack Sparrow", yards: 10, longest_rush: 2, touchdowns: 1})

      goku = player_fixture(%{name: "Goku", yards: 100, longest_rush: 3, touchdowns: 15})
      luke = player_fixture(%{name: "Luke Skywalker ", yards: 7, longest_rush: 4, touchdowns: 2})

      [jack_sparrow: jack_sparrow, goku: goku, luke: luke]
    end

    test "ok: returns all the players", %{jack_sparrow: jack, goku: goku, luke: luke} do
      assert %Page{
               entries: [^jack, ^luke],
               page_number: 1,
               page_size: 2,
               total_entries: 3,
               total_pages: 2
             } = Players.paginate_players(%{sort_by: "touchdowns", page: 1, page_size: 2})

      assert %Page{
               entries: [^goku],
               page_number: 2,
               page_size: 2,
               total_entries: 3,
               total_pages: 2
             } = Players.paginate_players(%{sort_by: "touchdowns", page: 2, page_size: 2})
    end
  end

  describe "migrate_player/1" do
    @attrs %{
      "Player" => "Christine Michael",
      "Team" => "GB",
      "Pos" => "RB",
      "Att" => 31,
      "Att/G" => 5.2,
      "Yds" => 114,
      "Avg" => 3.7,
      "Yds/G" => 19,
      "TD" => 1,
      "Lng" => "42T",
      "1st" => 5,
      "1st%" => 16.1,
      "20+" => 1,
      "40+" => 1,
      "FUM" => 0
    }

    test "ok: with T" do
      assert {:ok, %Player{} = player} = Players.migrate_player(@attrs)

      assert player.id
      assert player.name == @attrs["Player"]
      assert player.team == @attrs["Team"]
      assert player.position == @attrs["Pos"]
      assert player.attempts_per_game_avg == @attrs["Att/G"]
      assert player.attempts == @attrs["Att"]
      assert player.yards == @attrs["Yds"]
      assert player.yards_per_attempt_avg == @attrs["Avg"]
      assert player.yards_per_game == @attrs["Yds/G"]
      assert player.touchdowns == @attrs["TD"]
      assert player.longest_rush == 42
      assert player.is_longest_rush_touchdown == true
      assert player.first_downs == @attrs["1st"]
      assert player.first_downs_percentage == @attrs["1st%"]
      assert player.plus_20_yards == @attrs["20+"]
      assert player.plus_40_yards == @attrs["40+"]
      assert player.fumbles == @attrs["FUM"]
    end

    test "ok: without T" do
      attrs = Map.put(@attrs, "Lng", "42")
      assert {:ok, %Player{} = player} = Players.migrate_player(attrs)

      assert player.id
      assert player.name == attrs["Player"]
      assert player.team == attrs["Team"]
      assert player.position == attrs["Pos"]
      assert player.attempts_per_game_avg == attrs["Att/G"]
      assert player.attempts == attrs["Att"]
      assert player.yards == attrs["Yds"]
      assert player.yards_per_attempt_avg == attrs["Avg"]
      assert player.yards_per_game == attrs["Yds/G"]
      assert player.touchdowns == attrs["TD"]
      assert player.longest_rush == 42
      assert player.is_longest_rush_touchdown == false
      assert player.first_downs == attrs["1st"]
      assert player.first_downs_percentage == attrs["1st%"]
      assert player.plus_20_yards == attrs["20+"]
      assert player.plus_40_yards == attrs["40+"]
      assert player.fumbles == attrs["FUM"]
    end

    test "ok: yards as string" do
      attrs = Map.put(@attrs, "Yds", "1,333")
      assert {:ok, %Player{} = player} = Players.migrate_player(attrs)

      assert player.id
      assert player.name == attrs["Player"]
      assert player.team == attrs["Team"]
      assert player.position == attrs["Pos"]
      assert player.attempts_per_game_avg == attrs["Att/G"]
      assert player.attempts == attrs["Att"]
      assert player.yards == 1333
      assert player.yards_per_attempt_avg == attrs["Avg"]
      assert player.yards_per_game == attrs["Yds/G"]
      assert player.touchdowns == attrs["TD"]
      assert player.longest_rush == 42
      assert player.is_longest_rush_touchdown == true
      assert player.first_downs == attrs["1st"]
      assert player.first_downs_percentage == attrs["1st%"]
      assert player.plus_20_yards == attrs["20+"]
      assert player.plus_40_yards == attrs["40+"]
      assert player.fumbles == attrs["FUM"]
    end

    test "ok: longest rush as integer" do
      attrs = Map.put(@attrs, "Lng", 42)
      assert {:ok, %Player{} = player} = Players.migrate_player(attrs)

      assert player.id
      assert player.name == attrs["Player"]
      assert player.team == attrs["Team"]
      assert player.position == attrs["Pos"]
      assert player.attempts_per_game_avg == attrs["Att/G"]
      assert player.attempts == attrs["Att"]
      assert player.yards == attrs["Yds"]
      assert player.yards_per_attempt_avg == attrs["Avg"]
      assert player.yards_per_game == attrs["Yds/G"]
      assert player.touchdowns == attrs["TD"]
      assert player.longest_rush == 42
      assert player.is_longest_rush_touchdown == false
      assert player.first_downs == attrs["1st"]
      assert player.first_downs_percentage == attrs["1st%"]
      assert player.plus_20_yards == attrs["20+"]
      assert player.plus_40_yards == attrs["40+"]
      assert player.fumbles == attrs["FUM"]
    end
  end
end
