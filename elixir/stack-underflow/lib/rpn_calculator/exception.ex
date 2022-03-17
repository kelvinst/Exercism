defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    @default_message "stack underflow occurred"
    defexception message: @default_message

    @impl true
    def exception([]), do: %StackUnderflowError{}

    def exception(context) do
      %StackUnderflowError{message: "#{@default_message}, context: #{context}"}
    end
  end

  def divide([]), do: raise StackUnderflowError, "when dividing"
  def divide([_]), do: raise StackUnderflowError, "when dividing"
  def divide([0, _]), do: raise DivisionByZeroError
  def divide([x, y]), do: y / x
end

