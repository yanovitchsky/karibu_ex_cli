defmodule KaribuexCli.Client do
  use GenServer

  def start_link(services) do
    GenServer.start_link(__MODULE__, services, name: __MODULE__)
  end

  # API
  def call(service_name, payload) when is_binary(service_name) do
    GenServer.call(__MODULE__, {:call, String.to_atom(service_name), payload})
  end

  def call(service_name, payload) when is_atom(service_name) do
    GenServer.call(__MODULE__, {:call, service_name, payload})
  end

  # Callbacks
  def init(services) do
    IO.inspect "J init"
    {:ok, services}
  end

  def handle_call({:call, service_name, payload}, _from, services) do
    if is_defined?(services, service_name) do
      :poolboy.transaction(:request_pool, fn(worker) ->
        IO.inspect "worker pid: #{inspect(worker)}"
        case get_connection_string(services, service_name) do
          {:ok, uri} ->
            IO.inspect uri
            {:reply, {:ok, KaribuexCli.Requester.call(worker, uri, payload)}, services}
          {:error, reason} -> {:reply, {:error, reason}, services}
        end
      end)
    else
      {:reply, {:error, "service #{service_name} not declared"}, services}
    end
  end


  # Private helpers
  defp is_defined?(services, service_name) do
    names = Map.keys(services)
    Enum.member?(names, service_name)
  end

  defp get_connection_string(services, service_name) do
    service_url = Map.get(services, service_name)
    if String.length(service_url) == 0 do
      discover(service_name)
    else
      {:ok, service_url}
    end
  end

  defp discover(service_name) do
    case Convulse.discover(service_name) do
      {:ok, map} -> {:ok, "#{map[:address]}:#{map[:port]}"}
      {:error, reason} -> {:error, reason}
    end
  end
end

# KaribuexCli.Client.call(:sap_bridge, ["XenaController", "query", params])
#
# KaribuCli.Client.call(:xena, ["XenaController", "query", params])

# KaribuexCli.Client.call(:my_test, ["UserModuleTest", "echo", 10])
# for _ <- 1..10 do KaribuexCli.Client.call(:my_test, ["UserModuleTest", "echo", 10]) end
