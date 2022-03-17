defmodule RPNCalculator do
  def calculate!(stack, operation), do: operation.(stack)

  def calculate(stack, operation) do
    {:ok, operation.(stack)}
  rescue
    _ -> :error
  end

  def calculate_verbose(stack, operation) do
    {:ok, operation.(stack)}
  rescue
    e -> {:error, e.message}
  end
end
