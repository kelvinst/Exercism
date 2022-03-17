defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    files
    |> Stream.map(&{&1, grep_file(&1, pattern, flags)})
    |> handle_results(flags, files)
    |> Enum.join()
  end

  defp grep_file(file, pattern, flags) do
    regex = regex(pattern, flags)

    file
    |> File.stream!()
    |> Stream.with_index(1)
    |> filter(fn {content, _} -> content =~ regex end, flags)
    |> Stream.map(&line(&1, flags))
  end

  defp regex(pattern, flags) do
    pattern
    |> regex_pattern(flags)
    |> Regex.compile!(regex_opts(flags))
  end

  defp regex_pattern(pattern, ["-x" | _]), do: "^#{pattern}$"
  defp regex_pattern(pattern, []), do: pattern
  defp regex_pattern(pattern, [_ | rest]), do: regex_pattern(pattern, rest)

  defp regex_opts(["-i" | _]), do: "i"
  defp regex_opts([]), do: ""
  defp regex_opts([_ | rest]), do: regex_opts(rest)

  defp filter(stream, fun, ["-v" | _]), do: Stream.reject(stream, fun)
  defp filter(stream, fun, []), do: Stream.filter(stream, fun)
  defp filter(stream, fun, [_ | rest]), do: filter(stream, fun, rest)

  defp line({content, line}, ["-n" | _]), do: "#{line}:#{content}"
  defp line({content, _}, []), do: content
  defp line(content_line, [_ | rest]), do: line(content_line, rest)

  defp handle_results(result, ["-l" | _], _), do: only_file_names(result)
  defp handle_results(result, [], [_]), do: single_file(result)
  defp handle_results(result, [], _), do: multiple_files(result)
  defp handle_results(result, [_ | rest], files), do: handle_results(result, rest, files)

  defp only_file_names(result) do
    result
    |> Stream.reject(fn {_, stream} -> Enum.empty?(stream) end)
    |> Stream.map(&"#{elem(&1, 0)}\n")
  end

  defp single_file(result) do
    result
    |> Stream.map(&elem(&1, 1))
    |> Stream.flat_map(& &1)
  end

  defp multiple_files(result) do
    Stream.flat_map(result, fn {file, stream} ->
      Stream.map(stream, &"#{file}:#{&1}")
    end)
  end
end
