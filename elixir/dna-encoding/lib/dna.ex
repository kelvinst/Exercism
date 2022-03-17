defmodule DNA do
  @code_map %{
    ?\s => 0b0000,
    ?A => 0b0001,
    ?C => 0b0010,
    ?G => 0b0100,
    ?T => 0b1000
  }

  for {code, encoded_code} <- @code_map do
    def encode_nucleotide(unquote(code)), do: unquote(encoded_code)

    def decode_nucleotide(unquote(encoded_code)), do: unquote(code)
  end

  def encode(dna), do: encode(dna, <<>>)

  defp encode([], acc), do: acc

  defp encode([code | rest], acc) do 
    nucleotide = encode_nucleotide(code)
    encode(rest, <<acc::bitstring, nucleotide::size(4)>>)
  end

  def decode(dna), do: decode(dna, '')

  defp decode(<<>>, acc), do: Enum.reverse(acc)

  defp decode(<<encoded_code::size(4), rest::bitstring>>, acc) do 
    decode(rest, [decode_nucleotide(encoded_code) | acc])
  end
end
