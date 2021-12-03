defmodule TodoEts do
  @moduledoc """
  Documentation for Todo.
  """

  @table1 :disk_storage1
  @table2 :disk_storage2
  @table3 :disk_storage3
  @table4 :disk_storage4
  @table5 :disk_storage5
  @table6 :disk_storage6
  @table7 :disk_storage7
  @table8 :disk_storage8
  @table9 :disk_storage9
  @table10 :disk_storage10


  # name = @table1
  #   data_dir =@dir_name

  # defp dets_name(name) when is_atom(name), do: name

  defp file_dets_file(data_dir, name), do: :binary.bin_to_list("#{data_dir}/#{name}.db")

  def create_table() do
    File.mkdir_p!("data_dir")
    :dets.open_file(@table1, file:  file_dets_file("data_dir",@table1), type: :set)
    :dets.open_file(@table2, file:  file_dets_file("data_dir",@table2), type: :set)
    :dets.open_file(@table3, file:  file_dets_file("data_dir",@table3), type: :set)
    :dets.open_file(@table4, file:  file_dets_file("data_dir",@table4), type: :set)
    :dets.open_file(@table5, file:  file_dets_file("data_dir",@table5), type: :set)
    :dets.open_file(@table6, file:  file_dets_file("data_dir",@table6), type: :set)
    :dets.open_file(@table7, file:  file_dets_file("data_dir",@table7), type: :set)
    :dets.open_file(@table8, file:  file_dets_file("data_dir",@table8), type: :set)
    :dets.open_file(@table9, file:  file_dets_file("data_dir",@table9), type: :set)
    :dets.open_file(@table10, file:  file_dets_file("data_dir",@table10), type: :set)
  end

  def add(chunk) do
    key = gen_key()
    # key2 = gen_key()
    # key3 = gen_key()
    # key4 = gen_key()

    # there is no macanizm for checking same file that way ervery time file add and file size increaes
    # file = File.read!("./1mb.txt")
    :dets.insert(@table1, {key, chunk})

    :dets.sync(@table1)
    :dets.insert(@table2, {key, chunk})

    :dets.sync(@table2)
    :dets.insert(@table3, {key, chunk})

    :dets.sync(@table3)
    :dets.insert(@table4, {key, chunk})
    :dets.sync(@table4)

    :dets.insert(@table5, {key, chunk})
    :dets.sync(@table5)

    :dets.insert(@table6, {key, chunk})
    :dets.sync(@table6)

    :dets.insert(@table7, {key, chunk})
    :dets.sync(@table7)

    :dets.insert(@table8, {key, chunk})
    :dets.sync(@table8)

    :dets.insert(@table9, {key, chunk})
    :dets.sync(@table9)

    :dets.insert(@table10, {key, chunk})
    :dets.sync(@table10)

    # :timer.sleep(1000)

    # :timer.sleep(1000)

    # :timer.sleep(1000)

    # :timer.sleep(1000)

    # :timer.sleep(1000)

    # :timer.sleep(1000)

    # :timer.sleep(1000)

    # :timer.sleep(1000)

    # :timer.sleep(1000)

    # {key1, key2, key3, key4}
    {:ok, key}
  end

  def add_loop(count) when count < 1 do
    # close()
    IO.puts("Complete Loop")
    :ok
  end

  def add_loop(count) do
     key=  File.read!("./1mb.txt")
    |> add()
    # |> File.close()

    IO.puts("Loop#{count}")
    IO.inspect(key)

    # chunk = "hdjskfhsdjkfhjdskhfnudshfudshfuiseyhtjrebtuiaretgfjkadshgjghjerak"
    # add(chunk)
    add_loop(count - 1)

    # add(chunk)
  end

  def get(t, key) do
    value = :dets.select(t, key)
    value
  end

  def gen_key() do
    :crypto.strong_rand_bytes(10) |> Base.encode32()
  end

  def close do
    :dets.close(@table1)
  end


end
