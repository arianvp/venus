defmodule GameServer do
  use Application

  def start(_type, _args) do
    GameServer.Supervisor.start_link
  end
end
