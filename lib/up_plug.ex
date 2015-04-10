defmodule UpPlug do
  defstruct plug: nil, model: nil

  def is_csv?(plug) do
    content_type = plug.content_type
    csv_mimes = [
      Plug.MIME.type("csv")
    ]
    Enum.find_index(csv_mimes, fn(x) -> x == content_type end) != nil
  end

  def format_id(id) do
    if id != nil do
      if is_integer(id) do
        valid_id = id
      else
        valid_id = String.to_integer(id)
      end
      :io_lib.format("~4..0B", [valid_id])
        |> List.flatten
        |> to_string
    else
      ""
    end
  end

  def assign_filename(id, dt) do
    if id != nil do
      formatted_id = format_id(id)
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
    if up_plug.model.id do
      attachment_directory_path = \
        attachment_container_absolute_path(up_plug.model.id)
      #File.rm_rf(attachment_directory_path)
      if not File.exists?(attachment_directory_path) do
        File.mkdir_p(attachment_directory_path)
      end
      store_file(up_plug, attachment_directory_path)
      if is_csv?(up_plug.plug) do
        :ok
      end
    end
  end

  def store_file(up_plug, attachment_directory_path) do
    File.copy(up_plug.plug.path, Enum.join( \
      [attachment_directory_path, assign_filename(up_plug.model.id, \
        up_plug.model.created_at)], "/"), :infinity)
  end

  def attachment_container_relative_path(id) do
    Enum.join(["uploads", \
        format_id(id)], "/")
  end

  def attachment_container_absolute_path(id) do
    Enum.join([Mix.Project.app_path, "priv/static",
        attachment_container_relative_path(id)], "/")
  end

end