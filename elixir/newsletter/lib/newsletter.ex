defmodule Newsletter do
  def read_emails(path), do: path |> File.read!() |> parse_emails()

  defp parse_emails(""), do: []
  defp parse_emails(emails), do: emails |> String.trim() |> String.split("\n")

  def open_log(path), do: File.open!(path, [:write])

  def log_sent_email(pid, email), do: IO.puts(pid, email)

  def close_log(pid), do: File.close(pid)

  def send_newsletter(emails_path, log_path, send_fun) do
    log = open_log(log_path)

    for email <- read_emails(emails_path) do
      if send_fun.(email) == :ok, do: log_sent_email(log, email)
    end

    close_log(log)
  end
end
