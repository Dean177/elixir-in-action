defmodule TodoList do
  defstruct auto_id: 1, entries: Map.new

  def new(entries \\ []) do
    Enum.reduce(entries, %TodoList{}, fn(entry, todo_list) -> add_entry(todo_list, entry) end)
  end

  def add_entry(
    %TodoList{auto_id: id, entries: entries} = todo_list,
    entry
  ) do
    new_entry = Map.put(entry, :id, id)
    new_entries = Map.put(entries, id, new_entry)

    %TodoList{todo_list |
      auto_id: id + 1,
      entries: new_entries
    }
  end

  def delete_entry(
    %TodoList{entries: entries} = todo_list,
    entry_id
  ) do
    %TodoList{todo_list | entries: Map.delete(entries, entry_id)}
  end

  def update_entry(
    %TodoList{entries: entries} = todo_list,
    entry_id,
    updater_fun
  ) do
    case entries[entry_id] do
      nil -> todo_list
      old_entry ->
        old_id = old_entry.id
        new_entry = %{id: ^old_id} = updater_fun.(old_entry)
        new_entries = Map.put(entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def update_entry(todo_list, %{} = entry) do
    update_entry(todo_list, entry.id, fn(_) -> entry end)
  end

  def entries(%TodoList{entries: entries}, date) do
    entries
    |> Stream.filter(fn({_, entry}) -> entry.date == date end)
    |> Enum.map(fn({_, entry}) -> entry end)
  end
end

defimpl Collectable, for: TodoList do
  def into(original) do
    {original, &into_callback/2}
  end

  defp into_callback(todo_list, {:cont, entry}) do
    TodoList.add_entry(todo_list, entry)
  end

  defp into_callback(todo_list, :done) do
    todo_list
  end

  defp into_callback(_, :halt) do
   :ok
  end
end

defmodule TodoList.CsvImporter do
  defp parseEntry(entry) do
    [date, title] = String.split(entry, ",", parts: 2)
    [year, month, day] = String.split(date, "/", parts: 3)

    %{date: {year, month, day}, title: title}
  end

  def import(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&parseEntry/1)
    |> Enum.to_list
    |> TodoList.new
  end
end
