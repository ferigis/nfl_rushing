defmodule NFL.Rushing.Players do
  @moduledoc """
  Players' context.
  """

  alias NFL.Rushing.Players.Player
  alias NFL.Rushing.Repo

  import Ecto.Query

  @typedoc "Type for write operations response"
  @type wr_response :: {:ok, Player.t()} | {:error, Ecto.Changeset.t()}

  @doc """
  Creates a player.

  ## Examples
      iex> create_player(params)
      {:ok, %NFL.Rushing.Players.Player{}}
  """
  @spec create_player(map) :: wr_response
  def create_player(attrs \\ %{}) when is_map(attrs) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  List players filtering by params.

  ## Examples
      iex> list_players(params)
      [%NFL.Rushing.Players.Player{}]
  """
  @spec list_players(map) :: [Player.t(), ...]
  def list_players(args \\ %{}) when is_map(args) do
    args
    |> players_base_query()
    |> Repo.all()
  end

  @doc """
  Paginate players filtering by params.

  ## Examples
      iex> paginate_players(params)
      Scrivener.Page{}
  """
  @spec paginate_players(map) :: Scrivener.Page.t()
  def paginate_players(args \\ %{}) when is_map(args) do
    args
    |> players_base_query()
    |> Repo.paginate(args)
  end

  @doc """
  Migrates a player from the Json format creating him/her in the system.

  ## Examples
      iex> migrate_player(params)
      {:ok, %NFL.Rushing.Players.Player{}}
  """
  @spec migrate_player(map) :: wr_response
  def migrate_player(attrs \\ %{}) when is_map(attrs) do
    {longest_rush, touchdown?} = get_longest_rush(attrs["Lng"])

    params = %{
      name: attrs["Player"],
      team: attrs["Team"],
      position: attrs["Pos"],
      attempts_per_game_avg: attrs["Att/G"],
      attempts: attrs["Att"],
      yards: get_total_yards(attrs["Yds"]),
      yards_per_attempt_avg: attrs["Avg"],
      yards_per_game: attrs["Yds/G"],
      touchdowns: attrs["TD"],
      longest_rush: longest_rush,
      is_longest_rush_touchdown: touchdown?,
      first_downs: attrs["1st"],
      first_downs_percentage: attrs["1st%"],
      plus_20_yards: attrs["20+"],
      plus_40_yards: attrs["40+"],
      fumbles: attrs["FUM"]
    }

    create_player(params)
  end

  ## Private functions

  defp players_base_query(args) do
    q = from(player in Player)

    Enum.reduce(args, q, fn
      {:name, name}, query ->
        from(q in query, where: ilike(q.name, ^"%#{name}%"))

      {:sort_by, field}, query when field in ["yards", "longest_rush", "touchdowns"] ->
        order_by = order_by_q(args, field)
        from(q in query, order_by: ^order_by)

      _, query ->
        query
    end)
  end

  defp order_by_q(%{order_by: "desc"}, field) do
    [desc: String.to_existing_atom(field)]
  end

  defp order_by_q(_, field) do
    [asc: String.to_existing_atom(field)]
  end

  defp get_total_yards(raw) when is_integer(raw), do: raw

  defp get_total_yards(raw) when is_binary(raw) do
    {int, _} = raw |> String.replace(",", "") |> Integer.parse()
    int
  end

  defp get_longest_rush(raw) when is_integer(raw), do: {raw, false}

  defp get_longest_rush(raw) when is_binary(raw) do
    case Integer.parse(raw) do
      {int, ""} -> {int, false}
      {int, "T"} -> {int, true}
    end
  end
end
