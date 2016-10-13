defmodule KaribuexCli.Supervisor do
  use Supervisor

  def start_link do
    config = %{
      pool_size: Application.get_env(:karibuex_cli, :pool_size),
      services: Application.get_env(:karibuex_cli, :services)
    }
    Supervisor.start_link(__MODULE__, config)
  end

  def init(config) do
    pool_size = config[:pool_size] || 10
    request_pool_options = [
      name: {:local, :request_pool},
      worker_module: KaribuexCli.Requester,
      size: pool_size,
      max_overflow: round(pool_size/2)
    ]
    # raise inspect(request_pool_options)

    children = [
      :poolboy.child_spec(:request_pool, request_pool_options, []),
      worker(KaribuexCli.Client, [config[:services]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
