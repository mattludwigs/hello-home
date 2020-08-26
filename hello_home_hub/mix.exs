defmodule HelloHomeHub.MixProject do
  use Mix.Project

  def project do
    [
      app: :hello_home_hub,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      dialyzer: dialyzer(),
      deps: deps(),
      preferred_cli_env: [docs: :docs]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {HelloHomeHub.Application, []},
      included_applications: [:hello_home]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.22", only: :docs, runtime: false},
      {:hello_home, path: "../hello_home", runtime: false},
      {:jason, "~> 1.2"},
      {:vintage_net_wizard, "~> 0.3.0"}
    ]
  end

  defp dialyzer() do
    [
      flags: [:unmatched_returns, :error_handling, :race_conditions],
      plt_add_apps: [:eex, :mix]
    ]
  end
end
