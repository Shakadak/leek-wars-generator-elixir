defmodule Grid do
  @moduledoc """

  Grid creation


  :rand.seed(:exsplus, seed)
  """

  def disk(radius) do
    mkPair = fn x -> fn y -> {x, y} end end
    xs = -radius..radius
    ys = xs

    xs
    |> Enum.map(mkPair)
    |> Enum.flat_map(&Enum.map(ys, &1))
    |> Enum.filter(fn {x, y} -> (abs(x) + abs (y)) <= radius end)
  end

  def generate_count(grid, count) do
    grid
    |> Map.keys()
    |> Enum.take_random(count)
    |> Enum.map(&{&1, :obstacle})
    |> Enum.into(grid)
  end

  def generate_density(grid, _density) do
    grid
  end

  def place_participants(_grid, _participants) do
    %{}
  end

  def get_adjacent_cells({x, y}, grid) do
    grid
    |> Map.take([
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1},
    ])
  end

  def empty_area(starting_cell, grid) do
    explored_cells =
      starting_cell
      |> get_adjacent_cells(grid)
      |> Enum.filter(fn {_, x} -> x == :empty end)
      |> Enum.map(fn {x, _} -> x end)

    {current_area, unexplored_area} = Map.split(grid, [starting_cell, explored_cells])

    explored_cells
    |> Enum.map(&empty_area(&1, unexplored_area))
    |> Enum.reduce(current_area, &Enum.into/2)
  end

  def empty_areas(_grid) do
    []
  end
end
