defmodule GameServer.Protocol do
  @behaviour :ranch_protocol
  @behaviour :gen_fsm
  require Logger


  def start_link(ref, sock, trans, opts) do
    :proc_lib.start_link(__MODULE__ ,:init,[ref,sock,trans,opts])
  end

  def init(ref,sock,trans,opts) do
    :ok = :proc_lib.init_ack({:ok,self()})
    :ok = :ranch.accept_ack(ref)
    :ok = trans.setopts(sock, [active: true])

    state = {:state, sock, trans}
    :gen_fsm.enter_loop(__MODULE__,[],:handshake, [])
  end

  def handshake(event, state) do
    {:next_state, :event, {}}
  end

  def handshake_update(event, state) do
  end

  def handshake_game(event, state) do
  end

  def handle_info({:tcp,sock,data}, stateName, stateData) do

  end

end
