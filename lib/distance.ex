defmodule Numerix.Distance do
  @moduledoc """
  Distance functions between two vectors.
  """

  import Numerix.LinearAlgebra
  alias Numerix.{Common, Correlation}

  @doc """
  The Pearson's distance between two vectors.
  """
  @spec pearson([number], [number]) :: Common.maybe_float
  def pearson(vector1, vector2) do
    case Correlation.pearson(vector1, vector2) do
      nil -> nil
      correlation -> 1.0 - correlation
    end
  end

  @doc """
  The Minkowski distance between two vectors.
  """
  @spec minkowski([number], [number], integer) :: Common.maybe_float
  def minkowski(vector1, vector2, p \\ 3) do
    p |> norm(vector1 |> subtract(vector2))
  end

  @doc """
  The Euclidean distance between two vectors.
  """
  @spec euclidean([number], [number]) :: Common.maybe_float
  def euclidean(vector1, vector2) do
    vector1
    |> subtract(vector2)
    |> l2_norm
  end

  @doc """
  The Manhattan distance between two vectors.
  """
  @spec manhattan([number], [number]) :: Common.maybe_float
  def manhattan(vector1, vector2) do
    vector1
    |> subtract(vector2)
    |> l1_norm
  end

  @doc """
  The Jaccard distance (1 - Jaccard index) between two vectors.
  """
  @spec jaccard([number], [number]) :: Common.maybe_float
  def jaccard([], []), do: 0.0
  def jaccard([], _), do: nil
  def jaccard(_, []), do: nil
  def jaccard(vector1, vector2) do
    vector1
    |> Stream.zip(vector2)
    |> Enum.reduce({0, 0}, fn {x, y}, {intersection, union} ->
      case {x, y} do
        {x, y} when x == 0 or y == 0 ->
          {intersection, union}
        {x, y} when x == y ->
          {intersection + 1, union + 1}
        _ ->
          {intersection, union + 1}
      end
    end)
    |> to_jaccard_distance
  end

  defp to_jaccard_distance({intersection, union}) do
    1 - (intersection / union)
  end

end
