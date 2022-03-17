defmodule RPG.CharacterSheet do
  def welcome do
    IO.puts("Welcome! Let's fill out your character sheet together.")
  end

  def ask_name do
    IO.puts("What is your character's name?")
    IO.read(:line) |> String.trim()
  end

  def ask_class do
    IO.puts("What is your character's class?")
    IO.read(:line) |> String.trim()
  end

  def ask_level do
    IO.puts("What is your character's level?")
    IO.read(:line) |> String.trim() |> String.to_integer()
  end

  def run do
    welcome()

    %{
      name: ask_name(),
      class: ask_class(),
      level: ask_level()
    }
    |> IO.inspect(label: "Your character")
  end
end
