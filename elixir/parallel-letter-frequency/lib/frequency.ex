defmodule Frequency do
  @numbers 0..9 |> Enum.map(&to_string/1) 

  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> Enum.chunk_every(chunk_size(texts, workers))
    |> Enum.map(&Task.async(fn -> do_frequency(&1) end))
    |> Task.await_many()
    |> merge_results()
  end

  defp do_frequency(texts) do
    Enum.reduce(texts, %{}, fn text, acc ->
      text
      |> String.codepoints()
      |> Enum.filter(& &1 not in [",", " "] ++ @numbers)
      |> Enum.reduce(acc, fn letter, acc -> 
        Map.update(acc, String.downcase(letter), 1, & &1 + 1) 
      end)
    end)
  end

  defp merge_results(maps) do
    Enum.reduce(maps, %{}, fn counts, acc ->
      Enum.reduce(counts, acc, fn {letter, count}, acc ->
        Map.update(acc, letter, count, & &1 + count)
      end)
    end)
  end

  defp chunk_size(texts, workers) do
    size = round(length(texts) / workers)
    if size == 0, do: 1, else: size
  end
end
