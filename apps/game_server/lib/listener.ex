defmodule GameServer.Listener do
  require Logger
  def start_link() do
    Logger.info("Starting server")
    :ranch.start_listener(
      __MODULE__,
      100,
      :ranch_tcp,
      # TODO Config
      [{:port, 41934}],
      GameServer.Protocol,
      []
    )



  end
end
