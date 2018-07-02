defmodule GraphqlChat.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias GraphqlChat.Repo

  alias GraphqlChat.Messages.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages(args) do
    args
    |> messages_query
    |> Repo.all()
  end

  def list_messages() do
    Repo.all(Message)
  end

  def list_messages_from(args) do
    %{channel_id: channel_id} = args
    query =
      from(
        m in Message,
        where: m.channel_id == ^channel_id,
        order_by: [desc: m.inserted_at]
      )

    case args do
      %{cursor: cursor} ->
        %{entries: entries, metadata: metadata} =
          Repo.paginate(query, before: cursor, cursor_fields: [:inserted_at], limit: 30)

        {:ok, %{messages: entries, cursor: metadata.after}}

      _ ->
        %{entries: entries, metadata: metadata} =
          Repo.paginate(query, cursor_fields: [:inserted_at], limit: 30)

        IO.inspect metadata
        {:ok, %{messages: entries, cursor: metadata.after}}
    end
  end

  def messages_query(args) do
    Enum.reduce(args, Message, fn {:order, order}, query ->
      query |> order_by({^order, :inserted_at})
      # {:filter, filter}, query ->
      #   query |> filter_with(filter)
    end)
  end

  # defp filter_with(query, filter) do
  #   Enum.reduce(filter, query, fn
  #   {:name, name}, query ->
  #   from q in query, where: ilike(q.name, ^"%#{name}%")
  #   {:priced_above, price}, query ->
  #   from q in query, where: q.price >= ^price
  #   {:priced_below, price}, query ->
  #   from q in query, where: q.price <= ^price
  #   {:category, category_name}, query ->
  #   from q in query,
  #   join: c in assoc(q, :category),
  #   where: ilike(c.name, ^"%#{category_name}%")
  #   {:tag, tag_name}, query ->
  #   from q in query,
  #   join: t in assoc(q, :tags),
  #   where: ilike(t.name, ^"%#{tag_name}%")
  #   end)
  # end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{source: %Message{}}

  """
  def change_message(%Message{} = message) do
    Message.changeset(message, %{})
  end
end
