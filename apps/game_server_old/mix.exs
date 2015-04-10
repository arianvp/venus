defmodule GameServer.Mixfile do
  use Mix.Project

  def project do
    [app: :game_server,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
 [applications: [:logger, :ranch],
  mod: {GameServer, []}
 ]
  end

  defp deps do
    [ranch: "~> 1.0.0",
     isaac: "~> 0.0.1",
     rsa:   "~> 0.0.1"
    ]
  end
end
