defmodule Todo.Database do
  use GenServer

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder, name: :database_server)
  end

  def store(key, data) do
    key
    |> get_worker
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    key
    |> get_worker
    |> Todo.DatabaseWorker.get(key)
  end

  def get_worker(key) do
    GenServer.call(:database_server, {:get_worker, key})
  end

  def init(db_folder) do
    workers = for index <- 0..2, into: Map.new do
      {:ok, worker_pid} = Todo.DatabaseWorker.start(db_folder)
      {index, worker_pid}
    end

    {:ok, IO.inspect(workers)}
  end

  def handle_call({:get_worker, key}, _, workers) do
    {:reply, Map.get(workers, :erlang.phash2(key, 2)), workers}
  end
end
