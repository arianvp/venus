defmodule Venus.Listener do
  require Logger
  def start_link() do
    Logger.info("Starting server")
    {:ok, _} = :ranch.start_listener(
      __MODULE__,
      100,
      :ranch_tcp,
      [{:port, 41935}],
      Venus.Protocol,
      []
    )



  end
end
