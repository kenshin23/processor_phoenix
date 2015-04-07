defmodule UpPlug do
  import ExCsv
  defstruct plug: nil, model: nil

  def is_csv?(plug) do
    content_type = plug.content_type
    csv_mimes = [
      Plug.MIME.type("csv")
    ]
    Enum.find_index(csv_mimes, fn(x) -> x == content_type end) != nil
  end
end