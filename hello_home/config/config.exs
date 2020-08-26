# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :hello_home, HelloHomeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6NExuhM+Eod0V6lSI9SkgPNHPtZb2WJGsQUwkzzan5gpDCbXA/noJBGdLyni0g/8",
  render_errors: [view: HelloHomeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: HelloHome.PubSub,
  live_view: [signing_salt: "ZM/RP1lt"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :grizzly,
  runtime: [
    autostart: false,
    run_zipgateway_bin: false
  ],
  handlers: %{
    inclusion: HelloHome.ZWave.InclusionHandler
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
