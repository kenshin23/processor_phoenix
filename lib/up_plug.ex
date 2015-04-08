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

  def assign_filename(id, dt) do
    if id != nil do
      formatted_id = :io_lib.format("~4..0B", [id])
        |> List.flatten
        |> to_string
      date_as_string = [
        dt.year, 
        :io_lib.format("~2..0B", [dt.month]), 
        :io_lib.format("~2..0B", [dt.day]), 
        :io_lib.format("~2..0B", [dt.hour]), 
        :io_lib.format("~2..0B", [dt.min])] |> Enum.join("")
      filename = [formatted_id, date_as_string]
        |> List.flatten
        |> Enum.join("_")
      filename <> ".csv"
    else
      ""
    end
  end

  def process_upload_plug(up_plug) do
    model = assign_file_information(up_plug)
    up_plug = Map.put(up_plug, :model, model)
    post_process_file(up_plug)
    up_plug.model
  end

  def assign_file_information(up_plug) do
    plug = up_plug.plug
    model = up_plug.model
    model = Map.put(model, :created_at, Ecto.DateTime.utc)
    model = Map.put(model, :updated_at, Ecto.DateTime.utc)
    model = Map.put(model, :file_name, assign_filename(model.id, Ecto.DateTime.utc))
    model = Map.put(model, :file_size, size(plug))
    model
  end

  def size(plug) do
    File.stat!(plug.path).size
  end

  def content_type(plug) do
    plug.content_type
  end

  def post_process_file(up_plug) do
    # TODO
  end

end