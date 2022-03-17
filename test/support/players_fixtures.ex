defmodule NFL.Rushing.PlayersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NFL.Rushing.Players` context.
  """

  alias NFL.Rushing.Players

  @doc """
  Generate a player.
  """
  def player_fixture(attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{
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
      })
      |> Players.create_player()

    player
  end
end
