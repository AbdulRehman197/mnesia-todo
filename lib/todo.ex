defmodule Todo do
  @moduledoc """
  Documentation for Todo.
  """

  # defstruct students: %{
  #             1 => %{:name => "AbdulRehman", :marks => 45, :subject => "English"},
  #             2 => %{:name => "Talha", :marks => 60, :subject => "English"},
  #             3 => %{:name => "Talha", :marks => 60, :subject => "English"}
  #           }

  alias :mnesia, as: Mnesia
  @todo_ram :todo_ram
  @todo_disc :todo_disc
  @todo_copy :todo_copy
  @todo1 :todo1
  @todo2 :todo2
  @todo3 :todo3
  @todo4 :todo4
  @todo5 :todo5
  @todo6 :todo6
  @todo7 :todo7
  # @key 0
  # @table3 :todo3

  Mnesia.create_schema([node()])
  # Mnesia.create_schema([node()])
  # # Mnesia.create_schema([node() + 1])
  Mnesia.start()

  # def create_mnesia_table(count) when count < 1 do
  #   # Mnesia.dump_tables([@table, @table2, @table3])

  #   IO.puts("Tables Loop end")
  #   :ok
  # end

  # def create_mnesia_table(count) do
  #   Mnesia.create_table(
  #     :"table#{count}",
  #     type: :set,
  #     attributes: [:key, :text],
  #     disc_copies: [node()]
  #   )

  #   :timer.sleep(100)

  #   IO.puts("table#{count}")
  #   IO.puts("Table#{count}")

  #   create_mnesia_table(count - 1)
  # end

  def create_mnesia_table() do
    Mnesia.create_table(
      @todo_ram,
      type: :set,
      attributes: [:key, :text],
      disc_only_copies: [node()]
    )

    Mnesia.create_table(
      @todo_copy,
      type: :set,
      attributes: [:key, :text],
      disc_only_copies: [node()]
    )

    Mnesia.create_table(
      @todo_disc,
      type: :set,
      attributes: [:key, :text],
      disc_only_copies: [node()]
    )

    Mnesia.create_table(
      @todo1,
      type: :set,
      attributes: [:key, :text],
      disc_only_copies: [node()]
    )

    Mnesia.create_table(
      @todo2,
      type: :set,
      attributes: [:key, :text],
      disc_only_copies: [node()]
    )

    Mnesia.create_table(
      @todo3,
      type: :set,
      attributes: [:key, :text],
      disc_only_copies: [node()]
    )

    Mnesia.create_table(
      @todo4,
      type: :set,
      attributes: [:key, :text],
      disc_only_copies: [node()]
    )

    Mnesia.create_table(
      @todo5,
      type: :set,
      attributes: [:key, :text],
      disc_only_copies: [node()]
    )

    Mnesia.create_table(
      @todo6,
      type: :set,
      attributes: [:key, :text],
      disc_only_copies: [node()]
    )

    Mnesia.create_table(
      @todo7,
      type: :set,
      attributes: [:key, :text],
      disc_only_copies: [node()]
    )
  end

  def gen_key() do
    :crypto.strong_rand_bytes(10) |> Base.encode32()
  end

  def add(chunk, count) do
    key = gen_key()
    # key = @key
    # key = Mnesia.dirty_update_counter(@todo_ram, 1, 1)
    # IO.puts("key#{key}")

    Mnesia.transaction(fn ->
      Mnesia.write({@todo_copy, key, "Loop#{count}#{chunk}"})
      Mnesia.write({@todo_ram, key, chunk})
      Mnesia.write({@todo_disc, key, chunk})
      Mnesia.write({@todo1, key, chunk})
      Mnesia.write({@todo2, key, chunk})
      Mnesia.write({@todo3, key, chunk})
      Mnesia.write({@todo4, key, chunk})
      Mnesia.write({@todo5, key, chunk})
      Mnesia.write({@todo6, key, chunk})
      Mnesia.write({@todo7, key, chunk})
    end)

    :mnesia.dump_log()
    key
  end

  def add_disc(count) when count < 1 do
    # Mnesia.dump_tables([@table, @table2, @table3])

    IO.puts("Complete Loop")
  end

  def add_disc(count) do
    # chunk = gen_key()
    File.read!("./1mb.txt") |> add(count) |> File.close()
    # |> Task.async_stream(fn chunk ->
    #   # compute some work on the chunk
    #   Task.await(add(chunk))
    # end)
    # |> File.close()
    # add(chunk)
    :timer.sleep(100)
    IO.puts("Loop#{count}")
    add_disc(count - 1)
  end

  def show(key) do
    {:atomic, [row]} =
      Mnesia.transaction(fn ->
        Mnesia.read(@todo_copy, key)
      end)

    row
  end

  # def move_to_disc do

  # end
  def get_data(key) do
    {:atomic, [row]} =
      Mnesia.transaction(fn ->
        Mnesia.read(@todo_disc, key)
      end)

    row
  end

  def move_to_dics do
    Mnesia.transaction(fn ->
      Mnesia.foldl(
        fn {_, key, value}, _acc ->
          Mnesia.write({@todo_copy, key, value})
          IO.puts("Loop#{key}")
          :timer.sleep(1000)
        end,
        [],
        :todo_ram
      )
    end)

    IO.puts("Data Add Succesfully")
  end

  # move to ram

  def move_to_ram do
    Mnesia.transaction(fn ->
      Mnesia.foldl(
        fn {_, key, value}, _acc ->
          Mnesia.write({@todo_ram, key, value})
          IO.puts("Loop#{key}")
          :timer.sleep(1000)
        end,
        [],
        :todo_copy
      )
    end)

    IO.puts("Data Add Succesfully")
  end

  # def done(key) do
  #   {:atomic, :ok} =
  #     Mnesia.transaction(fn ->
  #       [{@table, ^key, text}] = Mnesia.read(@table, key)
  #       Mnesia.write({@table, key, text})
  #     end)

  #   key
  # end

  # def done(key) do
  #   {:atomic, :ok} =
  #     Mnesia.transaction(fn ->
  #       [{@table, ^key, text}] = Mnesia.read(@table, key)
  #       Mnesia.write({@table, key, text})
  #     end)

  #   key
  # end

  # def archive(key) do
  #   {:atomic, :ok} =
  #     Mnesia.transaction(fn ->
  #       [{@table, ^key, text, is_done, is_archived}] = Mnesia.read(@table, key)
  #       Mnesia.write({@table, key, text, is_done, true})
  #     end)

  #   key
  # end

  # def list() do
  #   list(all: false)
  # end

  # def list(opts) do
  #   {:atomic, rows} =
  #     Mnesia.transaction(fn ->
  #       Mnesia.select(@table, [{:_, [], [:"$_"]}])
  #     end)

  #   if !Keyword.get(opts, :all) do
  #     rows = rows |> Enum.filter(fn row = {_, _, _, _, is_archived} -> !is_archived end)
  #   end

  #   rows
  # end
end
