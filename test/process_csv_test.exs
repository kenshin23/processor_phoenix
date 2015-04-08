defmodule ProcessCsvTest do
  use ExUnit.Case
  import ProcessCsv

  test "An uploaded CSV file is really a valid CSV file" do
  	:pending
  end

  test "An invalid file (not parseable by ExCsv) results in an error" do
  	:pending
  end

  test "If headings are requested but the file doesn't have them, return an empty struct for them" do
  	:pending
  end
end