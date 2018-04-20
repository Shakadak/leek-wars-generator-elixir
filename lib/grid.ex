defmodule Grid do
  @moduledoc """

  Grid creation


  :rand.seed(:exsplus, seed)
  """

  @type grid :: %{{integer, integer} => :empty | :obstacle | :occupied}
  @type coordinates :: {integer, integer}

  @spec disk(pos_integer) :: grid
  def disk(radius) do
    mkPair = fn x -> fn y -> {x, y} end end
    xs = -radius..radius
    ys = xs

    xs
    |> Enum.map(mkPair)
    |> Enum.flat_map(fn f -> Enum.map(ys, f) end)
    |> Enum.filter(fn {x, y} -> (abs(x) + abs (y)) <= radius end)
    |> Enum.map(fn x -> {x, :empty} end)
    |> Enum.into(%{})
  end

  @spec generate_count(grid, non_neg_integer) :: grid
  def generate_count(grid, count) do
    grid
    |> Map.keys()
    |> Enum.take_random(count)
    |> Enum.map(fn x -> {x, :obstacle} end)
    |> Enum.into(grid)
  end

  def generate_density(grid, _density) do
    grid
  end

  def place_participants(_grid, _participants) do
    %{}
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

  @spec emtpty_area(coordinates, grid) :: grid
  def empty_grid(starting_cell, grid) do
    explored_cells =
      starting_cell
      |> get_adjacent_cells(grid)
      |> Enum.filter(&empty?/1)
      |> Enum.map(&fst/1)

    {current_area, unexplored_area} = Map.split(grid, [starting_cell, explored_cells])

    explored_cells
    |> Enum.map(fn x -> empty_area(x, unexplored_area) end)
    |> Enum.reduce(current_area, &Enum.into/2)
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

  defp fst({x, _}) do x end
end
