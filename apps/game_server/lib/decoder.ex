defmodule GameServer.Decoder do
  require Logger
  def handshake(data) do
    if byte_size(data) > 0 do
      case data do
        <<14, rest::binary>> ->
          {:handshake, %{service: :game}, rest}
      end
    else
      :more
    end
  end

  def login_handshake(data) do
    if byte_size(data) > 0 do
      <<username_hash,rest::binary>> = data
      {:login_handshake, %{username_hash: username_hash}, rest}

    else
      :more
    end
  end

  def login_header(data) do
    if byte_size(data) >= 2 do
      <<login_type, login_length, rest :: binary>> = data
      {:login_info, %{login_type: login_type, login_length: login_length}, rest}
    else
      :more
    end
  end

  def login_payload(data) do
    byte_size(data) |> inspect |> Logger.debug
    :unimplemented
  end
end
