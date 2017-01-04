defmodule Todo.Server do
  use GenServer

  def start_link(list_name) do
    IO.puts "Starting todo server for #{list_name}."
    GenServer.start_link(Todo.Server, list_name)
  end

  def add_entry(todo_server, entry) do
    GenServer.cast(todo_server, {:add_entry, entry})
  end

  def delete_entry(todo_server, entry_id) do
    GenServer.cast(todo_server, {:delete_entry, entry_id})
  end

  def entries(todo_server, date) do
    GenServer.call(todo_server, {:entries, date})
  end

  def update_entry(todo_server, entry) do
    GenServer.cast(todo_server, {:update_entry, entry})
  end

  def init(list_name) do
    {:ok, {list_name, Todo.Database.get(list_name) || Todo.List.new}}
  end

  def handle_call({:entries, date}, _, {_, todo_list}) do
    {:reply, Todo.List.entries(todo_list, date), todo_list}
  end

  def handle_cast({:add_entry, entry}, {list_name, todo_list}) do
    new_state = Todo.List.add_entry(todo_list, entry)
    Todo.Database.store(list_name, new_state)
    {:noreply, new_state}
  end

  def handle_cast({:delete_entry, entry_id}, {list_name, todo_list}) do
    new_state = Todo.List.delete_entry(todo_list, entry_id)
    Todo.Database.store(list_name, new_state)
    {:noreply, new_state}
  end

  def handle_cast({:update_entry, entry}, {list_name, todo_list}) do
    new_state = Todo.List.update_entry(todo_list, entry)
    Todo.Database.store(list_name, new_state)
    {:noreply, new_state}
  end
end
