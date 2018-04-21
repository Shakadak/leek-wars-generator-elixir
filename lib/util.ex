defmodule Util do
  @moduledoc """
  A collection of useful functions
  """

  def fst({x, _}) do x end
  def snd({_, x}) do x end
  
  def ok(x) do {:ok, x} end

  def liftA2(f, xs, ys) when is_function(f, 2) do
    for x <- xs, y <- ys do f.(x, y) end
  end

  def tuple2(x, y) do {x, y} end
end
