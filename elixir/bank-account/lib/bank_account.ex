defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank do 
    {:ok, account} = Agent.start(fn -> 0 end)
    account
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account), do: Agent.stop(account)

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do 
    with :ok <- check(account) do 
      Agent.get(account, & &1)
    end
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do 
    with :ok <- check(account) do 
      Agent.update(account, & &1 + amount)
    end
  end

  defp check(account) do
    if Process.alive?(account) do
      :ok
    else
      {:error, :account_closed}
    end
  end
end
