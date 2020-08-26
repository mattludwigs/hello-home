use Mix.Config

config :hello_home, HelloHomeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6NExuhM+Eod0V6lSI9SkgPNHPtZb2WJGsQUwkzzan5gpDCbXA/noJBGdLyni0g/8",
  render_errors: [view: HelloHomeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: HelloHome.PubSub,
  live_view: [signing_salt: "ZM/RP1lt"],
  http: [port: 4000],
  debug_errors: true,
  code_reloader: false,
  check_origin: false,
  server: true

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :nerves_runtime,
  target: "host"

config :grizzly,
  runtime: [
    autostart: false,
    run_zipgateway_bin: false
  ],
  handlers: %{
    inclusion: HelloHome.ZWave.InclusionHandler
  }

config :hello_home_hub,
  network: HelloHomeHub.Network.Mock

import_config "#{Mix.env()}.exs"
