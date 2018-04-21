defmodule Grid.Obstacle do
  @moduledoc """
  Obstacles' definitions
  """

  import Util

  @spec generate(Grid.t, :count, non_neg_integer) :: Grid.t
  def generate(grid, :count, count) do
    grid
    |> Map.keys()
    |> Enum.take_random(count)
    |> Enum.map(fn x -> {x, :obstacle} end)
    |> Enum.into(grid)
  end

  def generate(_grid, :density, _density) do
    raise "obstacle generation using density is not implemented"
  end

  def redimension_obstacle(grid, {x, y}, :square, size) do
    surface = liftA2(&{&1, &2}, range_slice(x, size), range_slice(y, size))
    cells =
      grid
      #|> Map.take(for x <- x..(x + size - 1), y <- y..(y + size - 1) do {x, y} end)
      |> Map.take(surface)
      |> Enum.filter(&Grid.empty?/1)

    if Enum.count(cells) < (size * size - 1) do
      :error
    else
      cells
      |> Enum.map(fn {x, _} -> {x, :obstacle} end)
      |> Enum.into(grid)
      |> ok()
    end
  end

  def redimension(grid, shape, size, count) do
    grid
    |> Enum.filter(&Grid.obstacle?/1)
    |> Enum.map(&fst/1)
    |> Enum.shuffle()
    |> Enum.reduce_while({grid, 0}, fn
      _, {grid, ^count} -> {:halt, {grid, count}}
      cell, {grid, count} -> case redimension_obstacle(grid, cell, shape, size) do
        {:ok, grid} -> {:cont, {grid, count + 1}}
        :error -> {:cont, {grid, count}}
      end
    end)
    |> elem(0)
  end

  def range_slice(x, len) do Range.new(x, x + len - 1) end
end
