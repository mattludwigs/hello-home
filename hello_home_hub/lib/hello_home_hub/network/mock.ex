defmodule HelloHomeHub.Network.Mock do
  @moduledoc """
  Mock network implementation for local dev

  ```elixir
  config :hello_home_hub,
    network: {HelloHomeHub.Network.Mock, [network_configured: true]}

  # the :network_configured option defaults to false. If the network is not
  # configured than vintage_net_wizard will start up
  config :hello_home_hub,
    network: HelloHomeHub.Network.Mock
  ```
  """

  @behaviour HelloHomeHub.Network

  @impl HelloHomeHub.Network
  def init(opts) do
    Keyword.get(opts, :network_configured, false)
  end

  @impl HelloHomeHub.Network
  def configured?(opts) do
    # From the init function the value is whatever is returned
    opts
  end
end
