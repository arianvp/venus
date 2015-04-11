PROTOCOL
========


We can model the game protocol as an FSM.

* login_handshake
* login_header
* login_payload
* game


handle_handshake do
receive do
  {:handshake, :game} -> handle_login
after 3000 do
  :error
end


defp handle_login do
  receive do
    {:login_handshake, hash } ->
      send(pid, {:exchange_data, 0, seed})
      handle_login_header
  end
end

defp handle_login_header do
  {:login_header, login_type} ->
    handle_login_payload
end



