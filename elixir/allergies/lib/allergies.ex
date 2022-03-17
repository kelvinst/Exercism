defmodule Allergies do
  use Bitwise

  @allergies %{
    1 => "eggs",
    2 => "peanuts",
    4 => "shellfish",
    8 => "strawberries",
    16 => "tomatoes",
    32 => "chocolate",
    64 => "pollen",
    128 => "cats"
  }

  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t()]
  def list(flags) do
    for {bit, allergy} <- @allergies, (bit &&& flags) == bit do
      allergy
    end
  end

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  for {bit, allergy} <- @allergies do
    def allergic_to?(flags, unquote(allergy)), do: (unquote(bit) &&& flags) == unquote(bit)
  end
end
