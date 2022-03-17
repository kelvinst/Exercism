defmodule RobotSimulator do
  defstruct [:direction, :position]

  @directions ~w(north east south west)a

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0})

  def create(dir, _) when dir not in @directions, do: {:error, "invalid direction"}

  def create(dir, {x, y}) when is_integer(x) and is_integer(y) do 
    %RobotSimulator{direction: dir, position: {x, y}}
  end

  def create(_, _), do: {:error, "invalid position"}

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(r, i) when is_binary(i), do: simulate(r, String.codepoints(i))

  def simulate(robot, instructions) when is_list(instructions) do 
    Enum.reduce_while(instructions, robot, fn i, r ->
      case do_simulate(r, i) do
        :error -> {:halt, {:error, "invalid instruction"}}
        result -> {:cont, result}
      end
    end)
  end

  def do_simulate(r, i) when i in ~w(R L), do: %{r | direction: turn(i, r.direction)}
  def do_simulate(r, "A"), do: %{r | position: advance(r.direction, r.position)}
  def do_simulate(_, _), do: :error

  defp turn("R", :north), do: :east
  defp turn("R", :east), do: :south
  defp turn("R", :south), do: :west
  defp turn("R", :west), do: :north

  defp turn("L", :north), do: :west
  defp turn("L", :east), do: :north
  defp turn("L", :south), do: :east
  defp turn("L", :west), do: :south

  defp advance(:north, {x, y}), do: {x, y + 1}
  defp advance(:east, {x, y}), do: {x + 1, y}
  defp advance(:south, {x, y}), do: {x, y - 1}
  defp advance(:west, {x, y}), do: {x - 1, y}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(%RobotSimulator{direction: direction}), do: direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(%RobotSimulator{position: position}), do: position
end
