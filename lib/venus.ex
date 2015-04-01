defmodule Venus do
  use Application

  def start(_type, _args) do
    Venus.Supervisor.start_link
  end
end
