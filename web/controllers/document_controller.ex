defmodule Processor.DocumentController do
  use Processor.Web, :controller

  alias Processor.Document

  plug :scrub_params, "document" when action in [:create, :update]
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
      Repo.insert(changeset)

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
end
