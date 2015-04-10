defmodule ProcessCsvTest do
  use ExUnit.Case
  import ProcessCsv

  setup do
    {
      :ok, \
      sample_image: %{ \
        filename: "sample.png", \
        path: "#{Path.expand("../", __DIR__)}/sample_data/sample.png" \
      }, \
      sample_csv: %{ \
        filename: "sample_csv.csv", \
        path:  "#{Path.expand("../", __DIR__)}/sample_data/sample_csv.csv" \
      }
    }
  end

  setup context do
    {
      :ok,
      Map.put(context, :up_plug, %UpPlug{ \
        plug: context[:sample_image]
      }) |>
      Map.put(:csv_up_plug, %UpPlug{ \
        plug: context[:sample_csv]
      })
    }
  end

  test "An uploaded CSV file is really a valid CSV file", context do
    content = %ExCsv.Table{
    	body: [["header_1", "example header 2", "header3", "header with, a comma1234", "This is content", "so is this",
               "this has 1234 numbers\r"]],
        headings: [],
        row_mapping: nil,
        row_struct: nil
    }
  	assert get_file_contents(context[:sample_csv].path) == {:ok, content}
  end

  test "An invalid file (not parseable by ExCsv) results in an error", context do
    result = get_file_contents(context[:sample_image].path)
    assert_raise ArgumentError, fn ->
      get_file_contents(context[:sample_image].path)
    end
  end

  test "If headings are requested but the file doesn't have them, return an empty struct for them" do
  	:pending
  end
end