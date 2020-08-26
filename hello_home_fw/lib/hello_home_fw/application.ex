defmodule HelloHomeFw.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloHomeFw.Supervisor]

    require Logger

    children =
      [
        # Children for all targets
        # Starts a worker by calling: HelloHomeFw.Worker.start_link(arg)
        # {HelloHomeFw.Worker, arg},
      ] ++ children(target())

    if HelloHomeHub.network_configured?() do
      HelloHomeHub.start_ui()
    else
      HelloHomeHub.run_wizard()
    end

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: HelloHomeFw.Worker.start_link(arg)
      # {HelloHomeFw.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: HelloHomeFw.Worker.start_link(arg)
      # {HelloHomeFw.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:hello_home_fw, :target)
  end
end
