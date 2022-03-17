defmodule Forth do
  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end

  @ops %{
    "+" => :+,
    "-" => :-,
    "*" => :*,
    "/" => :div
  }

  defstruct words: %{}, result: []

  @opaque evaluator :: %Forth{}

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new(), do: %Forth{}

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    s
    |> String.downcase()
    |> String.split(";")
    |> Enum.reduce(ev, &do_eval/2)
  end

  defp do_eval(string, ev) do
    list = parse(string)
    words = words(list, ev.words)
    %{ev | words: words, result: list |> replace_words(words) |> result()}
  end

  defp parse(""), do: []

  defp parse(string) do
    string
    |> String.split(~r{([^[:print:]]|[[:space:]]| )}u, trim: true)
    |> Enum.map(fn x ->
      case Integer.parse(x) do
        {int, ""} -> int
        _ -> x
      end
    end)
  end

  defp words([":", int | _], _) when is_integer(int), do: raise(InvalidWord, word: int)
  defp words([":", word | line], words), do: Map.put(words, word, replace_words(line, words))
  defp words(_, words), do: words

  defp replace_words(list, words) do
    Enum.flat_map(list, fn item ->
      if line = words[item] do
        line
      else
        [item]
      end
    end)
  end

  defp result([":" | _]), do: []
  defp result(list), do: result(list, [])

  defp result([], acc), do: Enum.reverse(acc)
  defp result(["dup" | _], _), do: raise(StackUnderflow)
  defp result([l, "dup" | t], acc), do: result([l, l | t], acc)
  defp result(["drop" | _], _), do: raise(StackUnderflow)
  defp result([_, "drop" | t], []), do: result(t, [])
  defp result([_, "drop" | t], [h | acc]), do: result([h | t], acc)
  defp result(["swap" | _], _), do: raise(StackUnderflow)
  defp result([_, "swap" | _], _), do: raise(StackUnderflow)
  defp result([l, r, "swap" | t], acc), do: result([r, l | t], acc)
  defp result(["over" | _], _), do: raise(StackUnderflow)
  defp result([_, "over" | _], _), do: raise(StackUnderflow)
  defp result([l, r, "over" | t], acc), do: result([l, r, l | t], acc)
  defp result([_, 0, "/" | _], _), do: raise(DivisionByZero)

  for {op, fun} <- @ops do
    defp result([unquote(op) | _], _), do: raise(StackUnderflow)
    defp result([_, unquote(op) | _], _), do: raise(StackUnderflow)

    defp result([l, r, unquote(op) | t], acc) do
      result = apply(Kernel, unquote(fun), [l, r])
      result([result | t], acc)
    end
  end

  defp result([h | t], acc) when is_integer(h), do: result(t, [h | acc])
  defp result([h | _], _), do: raise(UnknownWord, word: h)

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(ev), do: ev.result |> Enum.join(" ")
end
