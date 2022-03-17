defmodule NFL.Rushing.Repo.Migrations.AddPlayersTable do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :team, :string
      add :position, :string
      add :attempts_per_game_avg, :float
      add :attempts, :integer
      add :yards, :integer
      add :yards_per_attempt_avg, :float
      add :yards_per_game, :float
      add :touchdowns, :integer
      add :longest_rush, :integer
      add :is_longest_rush_touchdown, :boolean
      add :first_downs, :integer
      add :first_downs_percentage, :float
      add :plus_20_yards, :integer
      add :plus_40_yards, :integer
      add :fumbles, :integer

      timestamps()
    end

    create index(:players, [:yards])
    create index(:players, [:longest_rush])
    create index(:players, [:touchdowns])
  end
end
