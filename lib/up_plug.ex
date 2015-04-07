defmodule UpPlug do
  import ExCsv
  defstruct plug: nil, model: nil

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
end