defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  alias Discuss.Topic

  plug Discuss.Plugs.RequireAuth when action in [
    :new, :create, :edit, :update, :delete
  ]

  def index(conn, _params) do
    IO.inspect conn.assigns
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)
    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Please fix the errors below.")
        |> render "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)
    render conn, "edit.html",
      changeset: changeset,
      topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic =
      Topic |> Repo.get(topic_id)
    changeset =
      old_topic |> Topic.changeset(topic)
    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Please fix the errors below.")
        |> render "new.html", changeset: changeset, old_topic: topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Topic|> Repo.get!(topic_id) |> Repo.delete!
    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: topic_path(conn, :index))
  end
end
