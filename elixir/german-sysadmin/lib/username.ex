defmodule Username do
  def sanitize(username), do: sanitize(username, [])

  defp sanitize([], acc), do: Enum.reverse(acc)

  defp sanitize([char | rest], acc) do
    acc = case char do 
      char when char in ?a..?z -> [char | acc]
      ?_ -> [?_ | acc]
      ?ä -> 'ea' ++ acc
      ?ö -> 'eo' ++ acc
      ?ü -> 'eu' ++ acc
      ?ß -> 'ss' ++ acc
      _ -> acc
    end

    sanitize(rest, acc) 
  end
end
