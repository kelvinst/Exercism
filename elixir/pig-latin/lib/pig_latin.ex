defmodule PigLatin do
  @vowels 'aeiou'
  @vowel_sounds 'xy'
  @consonants Enum.filter(?a..?z, &(&1 not in @vowels))

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split(" ")
    |> Enum.map(&translate_word(&1, 0))
    |> Enum.join(" ")
  end

  defp translate_word("", _), do: ""

  for vowel <- @vowels do
    defp translate_word(<<unquote(vowel), _::binary>> = word, _), do: word <> "ay"
  end

  for vowel_sound <- @vowel_sounds, consonant <- @consonants do
    defp translate_word(<<unquote(vowel_sound), unquote(consonant), _::binary>> = word, _) do 
      word <> "ay"
    end
  end

  defp translate_word(<<"qu", rest::binary>>, _), do: rest <> "quay"

  defp translate_word(word, moved) when byte_size(word) == moved, do: word <> "ay"

  defp translate_word(<<consonant::binary-size(1), rest::binary>>, moved) do 
    translate_word(rest <> consonant, moved + 1)
  end
end
