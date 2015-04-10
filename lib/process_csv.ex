defmodule ProcessCsv do
  import ExCsv

  def get_file_contents(path) do
    if path != nil do
      file = File.read(path)
      case file do
        {:ok, content} ->
          table = ExCsv.parse!(content)
          IO.inspect table
          table
        {:error, error} ->
          {:error, error}
      end
    end
  end

end