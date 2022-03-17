defmodule NameBadge do
  def print(id, name, department) do
    department = department || "owner"

    if id do
      "[#{id}] - #{name} - #{String.upcase(department)}"
    else
      "#{name} - #{String.upcase(department)}"
    end
  end
end
