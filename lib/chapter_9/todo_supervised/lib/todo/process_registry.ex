defmodule Todo.ProcessRegistry do
  import Kernel, except: [send: 2]
  use GenServer

  def send(process_alias, message) do
    case whereis(process_alias) do
      :undefined -> {:badarg, {process_alias, message}}
      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  def start_link do
    IO.puts "Starting process registry"
    GenServer.start_link(__MODULE__, nil, :process_registry)
  end

  def unregister_name(process_alias) do
    GenServer.call(:process_registry, {:dereigister_name, process_alias})
  end

  def register_name(process_alias, pid) do
    GenServer.call(:process_registry, {:register_name, process_alias, pid})
  end

  def whereis(process_alias) do
    GenServer.call(:process_registry, {:whereis, process_alias})
  end

  def init(_) do
    {:ok, Map.new}
  end

  def handle_call({:register_name, process_alias, pid}, _, process_registry) do
    case Map.get(process_registry, process_alias, pid) do
      nil ->
        Process.monitor(pid)
        {:reply, :yes, Map.put(process_registry, process_alias, pid)}

      _ ->
        {:reply, :no, process_registry}
    end
  end

  def handle_call({:whereis, process_alias}, _, process_registry) do
    {:reply, Map.get(process_registry, process_alias), process_registry}
  end

  def handle_info({:DOWN, _, :process, pid, _}, process_registry) do
    {:noreply, deregister_pid(process_registry, pid)}
  end

  defp deregister_pid(process_registry, pid) do
    Enum.reduce(
      process_registry,
      process_registry,
      fn
        ({process_alias, process_id}, registry_acc) when process_id == pid ->
          Map.delete(registry_acc, process_alias)

        (_, registry_acc) -> registry_acc
      end
    )
  end
end