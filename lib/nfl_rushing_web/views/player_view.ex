defmodule NFL.RushingWeb.PlayerView do
  use NFL.RushingWeb, :view

  @doc false
  def render("index.json", %{entries: entries}) do
    %{data: render_many(entries, __MODULE__, "player.json")}
  end

  def render("index.csv", %{entries: entries}) do
    build_csv_list(entries)
  end

  def render("player.json", %{player: player}) do
    %{
      id: player.id,
      name: player.name,
      team: player.team,
      position: player.position,
      attempts_per_game_avg: player.attempts_per_game_avg,
      attempts: player.attempts,
      yards: player.yards,
      yards_per_attempt_avg: player.yards_per_attempt_avg,
      yards_per_game: player.yards_per_game,
      touchdowns: player.touchdowns,
      longest_rush: player.longest_rush,
      is_longest_rush_touchdown: player.is_longest_rush_touchdown,
      first_downs: player.first_downs,
      first_downs_percentage: player.first_downs_percentage,
      plus_20_yards: player.plus_20_yards,
      plus_40_yards: player.plus_40_yards,
      fumbles: player.fumbles
    }
  end

  ## Private functions

  defp build_csv_list(entries) do
    headers = [
      "Name",
      "Team",
      "Position",
      "Attempts/Game",
      "Attempts",
      "Yards",
      "Yards/Attempt",
      "Yards/Game",
      "Touchdowns",
      "Longest Rush",
      "Longest Rush TD",
      "First Downs",
      "First Downs %",
      "20+",
      "40+",
      "Fumbles"
    ]

    entries
    |> Enum.reduce([headers], fn player, acc ->
      [
        [
          player.name,
          player.team,
          player.position,
          player.attempts_per_game_avg,
          player.attempts,
          player.yards,
          player.yards_per_attempt_avg,
          player.yards_per_game,
          player.touchdowns,
          player.longest_rush,
          player.is_longest_rush_touchdown,
          player.first_downs,
          player.first_downs_percentage,
          player.plus_20_yards,
          player.plus_40_yards,
          player.fumbles
        ]
        | acc
      ]
    end)
    |> Enum.reverse()
    |> CSV.encode()
    |> Enum.to_list()
  end
end
