defmodule KaribuexCli do
  use Application

  def start(_type, _args) do
    KaribuexCli.Supervisor.start_link
  end
end
