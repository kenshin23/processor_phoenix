defmodule UpPlug do
  import ExCsv
  defstruct plug: nil, model: nil

  def is_csv?(plug) do
    true
  end
end