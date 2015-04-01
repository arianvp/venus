defmodule Jaggrab.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE,[])
  end

  def init(_args) do
    children = [worker(Jaggrab.Listener,[])]
    supervise(children, strategy: :one_for_one)
  end
end
