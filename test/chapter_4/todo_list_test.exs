defmodule TodoListTest do
  use ExUnit.Case

  doctest TodoList

  test "new" do
    assert TodoList.new() == %TodoList{auto_id: 1, entries: %{}}
  end

  @entry %{date: {2016, 5, 25}, title: "Hello"}
  @list TodoList.new([@entry])

  test "add_entry" do
    with_added_entry = TodoList.add_entry(TodoList.new(), @entry)
    assert with_added_entry == %TodoList{auto_id: 2, entries: %{1 => %{date: {2016, 5, 25}, title: "Hello", id: 1}}}
  end

  test "update_entry/2" do
    new_entry = %{date: {2016, 5, 25}, title: "Hi", id: 1}
    with_updated_entry = TodoList.update_entry(@list, new_entry)
    assert with_updated_entry ==  %TodoList{auto_id: 2, entries: %{1 => %{date: {2016, 5, 25}, title: "Hi", id: 1}}}
  end

  test "update_entry/3" do
      entry_updater = fn(old_entry) -> %{old_entry | title: "new new"} end
      with_updated_entry = TodoList.update_entry(@list, 1, entry_updater)
      assert with_updated_entry ==  %TodoList{auto_id: 2, entries: %{1 => %{date: {2016, 5, 25}, title: "new new", id: 1}}}
    end

  test "entries" do
    assert TodoList.entries(@list, @entry.date) == [%{date: {2016, 5, 25}, id: 1, title: "Hello"}]
  end

  @todo_csv_path "./test/chapter_4/todos.csv"
  test "import" do
    imported_todos = %TodoList{
      auto_id: 4,
      entries: %{
        1 => %{date: {"2013", "12", "19"}, id: 1, title: "Dentist"},
        2 => %{date: {"2013", "12", "20"}, id: 2, title: "Shopping"},
        3 => %{date: {"2013", "12", "19"}, id: 3, title: "Movies"}
      }
    }

    assert TodoList.CsvImporter.import(@todo_csv_path) == imported_todos
  end

  test "Collectable" do
    entries = [
      %{date: {"2013", "12", "19"}, id: 1, title: "Dentist"},
      %{date: {"2013", "12", "20"}, id: 2, title: "Shopping"}
    ]

    collected_list = for entry <- entries, into: TodoList.new, do: entry

    assert collected_list = %TodoList{
      auto_id: 3,
      entries: %{
        1 => %{date: {"2013", "12", "19"}, id: 1, title: "Dentist"},
        2 => %{date: {"2013", "12", "20"}, id: 2, title: "Shopping"},
      }
    }
  end
end