defmodule KaribuexCli.Requester do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [])
  end

  def call(pid, uri, payload) when is_list(payload) do
    GenServer.call(pid, {:execute, uri, payload})
  end

  # Callbacks

  def handle_call({:execute, uri, payload}, _from, state) do
    {[resource, method], params} = Enum.split(payload,2)
    request = KaribuexCli.Request.new(resource, method, params)
    {:ok, encoded_request} = KaribuexCli.Request.encode(request)
    [ip, port] = uri_term(uri)
    {:ok, socket} = :ezmq.start([{:type, :req}])
    :ezmq.connect(socket, :tcp, ip, port, [])
    packet = (encoded_request |> IO.iodata_to_binary)# <> <<0>>
    case :ezmq.send(socket, [packet]) do
      {:error, :no_connection} -> {:reply, {:error, "cannot connect to #{uri}"}, state}
      _ ->
        {:ok, packet} = :ezmq.recv(socket)
        {:ok, resp} = KaribuexCli.Response.decode(packet)
        :ezmq.close(socket)
        {:reply, resp, state}
    end
  end

  defp uri_term(uri) do
    [ip_string, port_string] = String.split(uri, ":")
    port = String.to_integer(port_string)
    [a, b, c, d] = String.split(ip_string, ".")
    [
      {String.to_integer(a), String.to_integer(b), String.to_integer(c), String.to_integer(d)},
       port
     ]
  end
end
