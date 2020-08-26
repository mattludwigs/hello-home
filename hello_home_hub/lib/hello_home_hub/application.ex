defmodule HelloHomeHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {HelloHomeHub.Networking, Application.get_env(:hello_home_hub, :network)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloHomeHub.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
