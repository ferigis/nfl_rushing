# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     NFL.Rushing.Repo.insert!(%NFL.Rushing.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias NFL.Rushing.Players

players = "rushing.json" |> File.read!() |> Jason.decode!()

Enum.each(players, fn player ->
  {:ok, migrated_player} = Players.migrate_player(player)
end)
