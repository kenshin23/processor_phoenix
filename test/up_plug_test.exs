defmodule UpPlugTest do
  use ExUnit.Case
  import UpPlug

  setup do
    {
      :ok, \
      sample_image_plug: %Plug.Upload{ \
        content_type: "image/png", \
        filename: "sample.png", \
        path: "#{Path.expand("../", __DIR__)}/sample_data/sample.png" \
      }, \
      sample_csv_plug: %Plug.Upload{ \
        content_type: "text/csv", \
        filename: "sample.csv", \
        path:  "#{Path.expand("../", __DIR__)}/sample_data/sample.csv" \
      }, \
      model_struct: %SampleModel{}
    }
  end

  setup context do
    {
      :ok,
      Map.put(context, :up_plug, %UpPlug{ \
        plug: context[:sample_image_plug], \
        model: context[:model_struct]
      }) |>
      Map.put(:csv_up_plug, %UpPlug{ \
        plug: context[:sample_csv_plug], \
        model: context[:model_struct]
      })
    }
  end

  test "is_csv? returns true if uploaded file is a csv file", context do
    assert is_csv?(context[:sample_csv_plug]) == true
  end

  test "is_csv? returns false if uploaded file is not an csv file", context do
    refute is_csv?(context[:sample_image_plug])
  end

  test "File is assigned name 0001_201504172045.csv if uploaded by user id 1 on 04/17/2015 at 8:45 pm" do
    assert assign_filename(1, %Ecto.DateTime{day: 17, hour: 20, min: 45, month: 4, sec: 23, year: 2015}) == "0001_201504172045.csv"
  end

  test "File is assigned name 4321_201511010123.csv if uploaded by user id 4321 on 11/01/2015 at 1:23 am" do
    assert assign_filename(4321, %Ecto.DateTime{day: 01, hour: 01, min: 23, month: 11, sec: 23, year: 2015}) == "4321_201511010123.csv"
  end

  test "assigns created_at attribute after saving the file", context do
    model = process_upload_plug(context[:up_plug])
    assert model.updated_at.__struct__ == Ecto.DateTime
  end

  test "assigns updated_at attribute after saving the file", context do
    model = process_upload_plug(context[:up_plug])
    assert model.updated_at.__struct__ == Ecto.DateTime
  end

  test "Uploaded file is stored in uploads folder", context do
    process_upload_plug(context[:csv_up_plug])
    expected_original_file_path = \
      "#{Mix.Project.app_path}/priv/static/uploads/0001/#{assign_filename(1, Ecto.DateTime.utc)}"
    assert File.exists?(expected_original_file_path)
  end

end