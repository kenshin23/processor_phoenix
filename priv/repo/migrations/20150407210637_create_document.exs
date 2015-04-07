defmodule Processor.Repo.Migrations.CreateDocument do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :file_name, :string
      add :file_size, :integer

      timestamps
    end
  end
end
