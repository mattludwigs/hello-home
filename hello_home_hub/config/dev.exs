use Mix.Config

config :vintage_net,
  resolvconf: "/dev/null",
  persistence: VintageNet.Persistence.Null

config :vintage_net_wizard,
  backend: VintageNetWizard.Backend.Mock,
  port: 4001,
  captive_portal: false
