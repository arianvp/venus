defmodule Jaggrab.Listener do
  def start_link do
    :ranch.start_listener(
      __MODULE__,
      100,
      :ranch_tcp,
      # TODO config
      [{:port, 43595}],
      []
    )
  end
end
