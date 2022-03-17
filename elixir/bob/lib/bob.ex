defmodule Bob do
  @spec hey(String.t()) :: String.t()
  def hey(input) do
    input = String.trim(input)
    question? = String.ends_with?(input, "?")
    yell? = String.match?(input, ~r/[[:alpha:]]/) and input == String.upcase(input)

    cond do
      input == "" -> "Fine. Be that way!"
      question? and yell? -> "Calm down, I know what I'm doing!"
      question? -> "Sure."
      yell? -> "Whoa, chill out!"
      true -> "Whatever."
    end
  end
end
