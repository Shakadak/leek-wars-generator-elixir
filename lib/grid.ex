defmodule Grid do
  @moduledoc """

  Grid creation


  :rand.seed(:exsplus, seed)
  """

  import Util

  alias Grid.Obstacle

  @type grid :: %{{integer, integer} => :empty | :obstacle | :occupied}
  @type coordinates :: {integer, integer}
  @type t :: grid

  @doc ~S"""
  Example usage `Grid.generate(:disk, [17], 30, %{1 => 4, 2 => 4})`
  """
  @spec generate(
        :disk, [non_neg_integer],
        non_neg_integer,
        %{any => pos_integer}
        ) :: {grid, %{any => [coordinates]}}
  def generate(type, dimensions, obstacles, teams) do
    grid = apply(Grid, type, dimensions)
      |> Obstacle.generate(:count, obstacles)
      |> Obstacle.redimension(:square, 2, trunc(obstacles / 2))

    placement_grid =
      grid
      |> Grid.empty_grids()
      |> Enum.max_by(&Enum.count/1)

    nb_participants = teams |> Map.values() |> Enum.sum()
    if map_size(placement_grid) < nb_participants do
      raise "Not enough free space to place participants"
    end

    max_tries = 500
    placement = place_participants(placement_grid, teams, dimensions, max_tries)

    grid =
      placement
      |> Map.values()
      |> Enum.concat()
      |> Enum.map(fn x -> {x, :occupied} end)
      |> Enum.into(grid)

    {grid, placement}
  end

  @spec disk(pos_integer) :: grid
  def disk(radius) do
    mkPair = fn x, y -> {x, y} end
    xs = -radius..radius
    ys = xs

    liftA2(mkPair, xs, ys)
    |> Enum.filter(fn {x, y} -> (abs(x) + abs (y)) <= radius end)
    |> Enum.map(fn x -> {x, :empty} end)
    |> Enum.into(%{})
  end

  def place_participants(grid, teams, dimensions, max_tries) do
    average_dim = Enum.sum(dimensions) / Enum.count(dimensions)

    fn ->
      generate_individual(teams, grid)
    end
    |> Stream.repeatedly()
    |> Enum.reduce_while({max_tries, average_dim}, fn x, {tries, average_dim} ->
      if evaluate_fitness(x) >= average_dim do
        {:halt, x}
      else
        if tries == 0 do
          {:cont, {max_tries, average_dim - 1}}
        else
          {:cont, {tries - 1, average_dim}}
        end
      end
    end)
  end

  @spec get_adjacent_cells(coordinates, grid) :: grid
  def get_adjacent_cells({x, y}, grid) do
    grid
    |> Map.take([
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1},
    ])
  end

  @spec empty_grid(coordinates, grid) :: grid
  def empty_grid(starting_cell, grid) do
    empty_grid_go([starting_cell], grid, %{})
  end

  defp empty_grid_go([], _, acc) do
    acc
  end
  defp empty_grid_go(starting_cells, grid, acc) do
    {current_area, grid} = Map.split(grid, starting_cells)
    wave =
      starting_cells
      |> Enum.flat_map(fn x -> get_adjacent_cells(x, grid) end)
      |> Enum.filter(&empty?/1)
      |> Enum.map(&fst/1)
      |> Enum.uniq()

    empty_grid_go(wave, grid, Map.merge(current_area, acc))
  end

  @spec empty_grids(grid) :: [grid]
  def empty_grids(grid) do
    empty_cells =
      grid
      |> Enum.filter(&empty?/1)
      |> Enum.map(&fst/1)

    if empty_cells == [] do
      []
    else
      empty_grid = empty_grid(Enum.random(empty_cells), grid)
      {_, unexplored_area} = Map.split(grid, Map.keys(empty_grid))
      [empty_grid | empty_grids(unexplored_area)]
    end
  end

  def empty?({_, :empty}) do true end
  def empty?({_, _}) do false end

  def obstacle?({_, :obstacle}) do true end
  def obstacle?({_, _}) do false end

  defp split_random_n(map, n) do
    keys =
      map
      |> Map.keys()
      |> Enum.take_random(n)

    Map.split(map, keys)
  end

  defp manhattan({x, y}, {p, q}) do
    abs(x - p) + abs(y - q)
  end

  # GENETIC ALGO

  def evaluate_fitness(teams) do
    teams
    |> Enum.flat_map(fn {team, positions} ->
      other_positions =
        teams
        |> Map.delete(team)
        |> Map.values()
        |> Enum.concat()
      liftA2(&manhattan/2, positions, other_positions)
    end)
    |> Enum.min()
  end

  def generate_individual(teams, grid) do
    {teams, _} = Enum.reduce(teams, {%{}, grid}, fn {team, nb_members}, {teams, grid} ->
      {positions, grid} = split_random_n(grid, nb_members)
      {Map.put(teams, team, Map.keys(positions)), grid}
    end)
    teams
  end

  def mutate_individual(_) do
    %{}
  end

  def breed_individuals(_, _) do
    {%{}, %{}}
  end

  def print(grid, :disk, [radius]) do
    for x <- -radius..radius do
      for y <- -radius..radius do
        case grid[{x, y}] do
          nil -> "  "
          :empty -> "░░"
          :obstacle -> "▓▓"
          :occupied -> "[]"
        end
      end
      |> IO.puts()
    end
  end
end
