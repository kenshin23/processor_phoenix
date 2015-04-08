defmodule Processor.DocumentController do
  use Processor.Web, :controller

  alias Processor.Document

  #plug :scrub_params, "document" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    documents = Repo.all(Document)
    render conn, "index.html", documents: documents
  end

  def new(conn, _params) do
    changeset = Document.changeset(%Document{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"document" => document_params}) do
    changeset = Document.changeset(%Document{}, document_params)

    if changeset.valid? do
      doc = Repo.insert(changeset)
      # Validate the uploaded file and populate model with updated values:
      upload_file_attachment(doc, changeset.params, "upload_file")

      conn
      |> put_flash(:info, "Document created succesfully.")
      |> redirect(to: document_path(conn, :index))
    else
      render conn, "new.html", changeset: changeset
    end
  end

  def show(conn, %{"id" => id}) do
    document = Repo.get(Document, id)
    render conn, "show.html", document: document
  end

  def edit(conn, %{"id" => id}) do
    document = Repo.get(Document, id)
    changeset = Document.changeset(document)
    render conn, "edit.html", document: document, changeset: changeset
  end

  def update(conn, %{"id" => id, "document" => document_params}) do
    document = Repo.get(Document, id)
    changeset = Document.changeset(document, document_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "Document updated succesfully.")
      |> redirect(to: document_path(conn, :index))
    else
      render conn, "edit.html", document: document, changeset: changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    document = Repo.get(Document, id)
    Repo.delete(document)

    conn
    |> put_flash(:info, "Document deleted succesfully.")
    |> redirect(to: document_path(conn, :index))
  end

  defp upload_file_attachment(document, params, attachment_attribute_name) do
    IO.puts "Now uploading the file...\n"
    IO.puts "Inspecting params.attachment_attribute_name:\n"
    IO.inspect params[attachment_attribute_name]
    if (params[attachment_attribute_name] != nil and \
            String.length(params[attachment_attribute_name].filename) > 0) do
      document = UpPlug.process_upload_plug(%UpPlug{
        model: document,
        plug: params[attachment_attribute_name]
      })

      IO.puts "Inspecting document after upload_file_attachment"
      IO.inspect document

      document = Map.delete(document, :upload_file)
      Repo.update(document)
    else
      IO.puts "Failed to process file due to error."
    end
  end
end
