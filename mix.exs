defmodule KaribuexCli.Mixfile do
  use Mix.Project

  def project do
    [app: :karibuex_cli,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     preferred_cli_env: [espec: :test],
     deps: deps(),
     elixirc_paths: elixirc_paths(Mix.env),
     package: package,
     docs: [
       extras: ["README.md"],
       main: "readme",
     ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :ezmq, :poolboy, :msgpax, :convulse],
      mod: {KaribuexCli, []}
  ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ezmq, git: "https://github.com/zeromq/ezmq.git"},
      # {:czmq, github: "gar1t/erlang-czmq", compile: "./configure; make"},
      {:convulse, git: "git@gitlab.visibleo.fr:visibleornd/convulse-ex.git"},
      {:poolboy, "~> 1.5"},
      {:msgpax, "~> 0.8"},
      {:secure_random, "~> 0.5"},
      {:espec, "~> 0.8.18", only: :test}
    ]
  end

  defp package do
    %{ licenses: ["MIT"] }
  end

  defp elixirc_paths(:test), do: ["lib", "spec/support"]
  defp elixirc_paths(_), do: ["lib"]
end
