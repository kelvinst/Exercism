defmodule ZebraPuzzle do
  @positions 1..5
  @nationalities ~w(englishman norwegian ukrainian japanese spaniard)a
  @colors ~w(red green ivory yellow blue)a
  @drinks ~w(coffee tea milk orange_juice water)a
  @pets ~w(dog snails fox horse zebra)a
  @cigarettes ~w{old_gold kool chesterfield lucky_strike parliament}a

  @doc """
  Determine who drinks the water
  """
  @spec drinks_water() :: atom
  def drinks_water, do: Enum.find(solve(), & &1.drink == :water)[:nationality]

  @doc """
  Determine who owns the zebra
  """
  @spec owns_zebra() :: atom
  def owns_zebra, do: Enum.find(solve(), & &1.pet == :zebra)[:nationality]

  def solve do
    [solution] =
      all_possibilities()
      |> Stream.filter(&by_fields(&1, nationality: :englishman, color: :red))
      |> Stream.filter(&by_fields(&1, nationality: :spaniard, pet: :dog))
      |> Stream.filter(&by_fields(&1, drink: :coffee, color: :green))
      |> Stream.filter(&by_fields(&1, nationality: :ukrainian, drink: :tea))
      |> Stream.filter(&by_fields(&1, cigarette: :old_gold, pet: :snails))
      |> Stream.filter(&by_fields(&1, cigarette: :kool, color: :yellow))
      |> Stream.filter(&by_fields(&1, drink: :milk, position: 3))
      |> Stream.filter(&by_fields(&1, nationality: :norwegian, position: 1))
      |> Stream.filter(&by_fields(&1, cigarette: :lucky_strike, drink: :orange_juice))
      |> Stream.filter(&by_fields(&1, nationality: :japanese, cigarette: :parliament))
      |> Enum.group_by(& &1.position)
      |> possible_arrangements()
      |> Stream.reject(&duplicated_field(&1, :nationality))
      |> Stream.reject(&duplicated_field(&1, :color))
      |> Stream.reject(&duplicated_field(&1, :drink))
      |> Stream.reject(&duplicated_field(&1, :pet))
      |> Stream.reject(&duplicated_field(&1, :cigarette))
      |> Stream.filter(&by_neighbor(&1, :right, color: :green, color: :ivory))
      |> Stream.filter(&by_neighbor(&1, :any, cigarette: :chesterfield, pet: :fox))
      |> Stream.filter(&by_neighbor(&1, :any, cigarette: :kool, pet: :horse))
      |> Stream.filter(&by_neighbor(&1, :any, nationality: :norwegian, color: :blue))
      |> Enum.to_list()

    solution
  end

  defp all_possibilities do
    Stream.flat_map(@positions, fn position ->
      Stream.flat_map(@nationalities, fn nationality ->
        Stream.flat_map(@colors, fn color ->
          Stream.flat_map(@pets, fn pet ->
            Stream.flat_map(@drinks, fn drink ->
              Stream.map(@cigarettes, fn cigarette ->
                %{
                  position: position,
                  nationality: nationality,
                  color: color,
                  pet: pet,
                  drink: drink,
                  cigarette: cigarette
                }
              end)
            end)
          end)
        end)
      end)
    end)
  end

  defp by_fields(possibility, [{field1, value1}, {field2, value2}]) do
    (possibility[field1] == value1 and possibility[field2] == value2) or
      (possibility[field1] != value1 and possibility[field2] != value2)
  end

  defp duplicated_field(arrangement, field) do 
    arrangement
    |> Enum.map(& &1[field])
    |> duplicated?()
  end

  defp duplicated?(list), do: duplicated?(list, false)
  defp duplicated?(_, true), do: true
  defp duplicated?([], false), do: false
  defp duplicated?([h | t], false), do: duplicated?(t, h in t)

  defp possible_arrangements(possibilities_by_position) do
    Stream.flat_map(possibilities_by_position[1], fn p1 ->
      Stream.flat_map(possibilities_by_position[2], fn p2 ->
        Stream.flat_map(possibilities_by_position[3], fn p3 ->
          Stream.flat_map(possibilities_by_position[4], fn p4 ->
            Stream.map(possibilities_by_position[5], fn p5 ->
              [p1, p2, p3, p4, p5]
            end)
          end)
        end)
      end)
    end)
  end

  defp by_neighbor(arrangement, direction, [{field, value}, {neighbor_field, neighbor_value}]) do
    arrangement
    |> find_neighbors(direction, field, value, nil)
    |> Enum.any?(&(&1[neighbor_field] == neighbor_value))
  end

  defp find_neighbors([possibility | rest], direction, field, value, left) do
    if possibility[field] == value do
      get_neighbors(left, rest, direction)
    else
      find_neighbors(rest, direction, field, value, possibility)
    end
  end

  defp get_neighbors(_, [], :right), do: []
  defp get_neighbors(_, [right | _], :right), do: [right]
  defp get_neighbors(left, [], :any), do: [left]
  defp get_neighbors(left, [right | _], :any), do: [left, right]
end
