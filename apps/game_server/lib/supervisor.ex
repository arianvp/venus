defmodule GameServer.Supervisor do
  use Supervisor
  def start_link do
    Supervisor.start_link(__MODULE__,[])
  end

  def init(_args) do
    children = [
      :ranch.child_spec(
        GameServer.Listener,
        100,
        :ranch_tcp,
        [{:port, 43594}],
        GameServer.Protocol,
        []
      )

    ]

    supervise(children, strategy: :one_for_one)
  end
end
