defmodule Jaggrab do
  use Application

  def start(_type,_args) do
    Jaggrab.Supervisor.start_link
  end
end
