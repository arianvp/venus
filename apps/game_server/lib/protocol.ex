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
    :gen_fsm.enter_loop(__MODULE__,[],:handshake, %{
      trans: trans,
      sock: sock,
      rest: <<>>
    })
  end

  def send_data(ctx, data) do
    ctx.trans.send(ctx.sock,data)
  end


  def handshake(ev, ctx) do
    {:handshake, %{service: service}} = ev
    case service do
      :game   -> {:next_state, :login_handshake, ctx}
    end
  end

  def login_handshake({:login_handshake, data}, ctx) do
    username_hash = data.username_hash
    ctx = ctx
    |> Dict.put(:server_seed, 0)
    |> Dict.put(:username_hash, username_hash)

    send_data(ctx, <<0,0::size(64), ctx.server_seed::size(64)>>)

    {:next_state, :login_header, ctx}
  end

  def login_header(ev,ctx) do
    ev
    |> inspect
    |> Logger.debug
    throw :unimplemented
    {:next_state, :login_payload, ctx}
  end

  def login_payload(ev,ctx) do
    throw :unimplemented
    {:nex_state, :game, ctx}
  end

  @doc """
  Handle tcp data
  """

  # TODO make ctx a session
  def handle_info({:tcp,sock,data}, state_name, ctx) do
    :inet.setopts(sock,[active: :once])
    :gen_fsm.start_timer(1000, :heartbeat)
    handle_data(state_name, %{ctx | rest: ctx.rest<> data})
  end


  # will decode as many packets as possible returns a list of events
  # TODO rewrite to use a "decoding" state
  def handle_data(state_name, ctx) do
    case apply(GameServer.Decoder, state_name, [ctx.rest]) do
      :more ->
        {:next_state, state_name, ctx}
      {event, event_args, rest} ->
        {event,event_args} |> inspect |> Logger.debug
        {:next_state, state_name, ctx} =
          :gen_fsm.sync_send_event( self(), {event,event_args})
        handle_data(state_name, %{ctx | rest: rest})
    end
  end

  def terminate(reason,state_name,state_data) do

  end
end
