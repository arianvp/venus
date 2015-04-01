defmodule GameServer.Supervisor do
  use Supervisor
  def start_link do
    Supervisor.start_link(__MODULE__,[])
  end

  def init(_args) do
    children = [worker(GameServer.Listener, [])]

    supervise(children, strategy: :one_for_one)
  end
end
