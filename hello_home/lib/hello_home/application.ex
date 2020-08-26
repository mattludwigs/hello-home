defmodule HelloHome.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      HelloHomeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: HelloHome.PubSub},
      # Start the Endpoint (http/https)
      HelloHomeWeb.Endpoint
      # Start a worker by calling: HelloHome.Worker.start_link(arg)
      # {HelloHome.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: HelloHome.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    HelloHomeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
