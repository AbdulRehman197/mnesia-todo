defmodule Todo do
  @moduledoc """
  Documentation for Todo.
  """

  alias :mnesia, as: Mnesia
  @table :todo
  @table1 :todo1

  # Mnesia.create_schema([node()])
  Mnesia.create_schema([node()])
  # Mnesia.create_schema([node() + 1])
  Mnesia.start()

  @spec create_mnesia_table :: any
  def create_mnesia_table() do
    Mnesia.create_table(
      @table,
      type: :set,
      attributes: [:key, :text, :is_done, :is_archived],
      disc_copies: [node()]
    )
  end

  def gen_key() do
    :crypto.strong_rand_bytes(10) |> Base.encode32()
  end

  def add(text) do
    key = gen_key()

    {:atomic, :ok} =
      Mnesia.transaction(fn ->
        Mnesia.write({@table, key, text, false, false})
        # Mnesia.write({@table1, key, text, false, false})
      end)

    key
  end

  def add_loop(text, count) when count < 1, do: IO.puts("Complete Loop")

  def add_loop(text, count) do
    add("#{text} #{count}")
    add_loop(text, count - 1)
  end

  def show(key) do
    {:atomic, [row]} =
      Mnesia.transaction(fn ->
        Mnesia.read(@table, key)
      end)

    row
  end

  def done(key) do
    {:atomic, :ok} =
      Mnesia.transaction(fn ->
        [{@table, ^key, text, is_done, is_archived}] = Mnesia.read(@table, key)
        Mnesia.write({@table, key, text, true, is_archived})
      end)

    key
  end

  def archive(key) do
    {:atomic, :ok} =
      Mnesia.transaction(fn ->
        [{@table, ^key, text, is_done, is_archived}] = Mnesia.read(@table, key)
        Mnesia.write({@table, key, text, is_done, true})
      end)

    key
  end

  def list() do
    list(all: false)
  end

  def list(opts) do
    {:atomic, rows} =
      Mnesia.transaction(fn ->
        Mnesia.select(@table, [{:_, [], [:"$_"]}])
      end)

    if !Keyword.get(opts, :all) do
      rows = rows |> Enum.filter(fn row = {_, _, _, _, is_archived} -> !is_archived end)
    end

    rows
  end
end
