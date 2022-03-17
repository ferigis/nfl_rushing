defmodule NFL.Rushing.Players.Player do
  @moduledoc """
  Schema for Players
  """

  use Ecto.Schema

  import Ecto.Changeset

  @typedoc "Player's type"
  @type t :: %__MODULE__{}

  @fields [
    :name,
    :team,
    :position,
    :attempts_per_game_avg,
    :attempts,
    :yards,
    :yards_per_attempt_avg,
    :yards_per_game,
    :touchdowns,
    :longest_rush,
    :is_longest_rush_touchdown,
    :first_downs,
    :first_downs_percentage,
    :plus_20_yards,
    :plus_40_yards,
    :fumbles
  ]

  schema "players" do
    field :name, :string
    field :team, :string
    field :position, :string
    field :attempts_per_game_avg, :float
    field :attempts, :integer
    field :yards, :integer
    field :yards_per_attempt_avg, :float
    field :yards_per_game, :float
    field :touchdowns, :integer
    field :longest_rush, :integer
    field :is_longest_rush_touchdown, :boolean
    field :first_downs, :integer
    field :first_downs_percentage, :float
    field :plus_20_yards, :integer
    field :plus_40_yards, :integer
    field :fumbles, :integer

    timestamps()
  end

  @doc false
  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(t, attrs) do
    t
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
