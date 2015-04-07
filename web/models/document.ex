defmodule Processor.Document do
  use Processor.Web, :model

  schema "documents" do
    field :file_name, :string
    field :file_size, :integer

    timestamps
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ nil) do
    cast(model, params, ~w(file_name file_size), ~w())
  end
end
