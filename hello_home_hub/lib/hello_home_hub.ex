defmodule HelloHomeHub do
  @moduledoc """
  API for controlling the hub
  """

  @type wizard_opt() :: {:run_ui, boolean()}

  alias HelloHomeHub.Networking

  @doc """
  Check if the network is ready
  """
  @spec network_configured?() :: boolean()
  def network_configured?() do
    Networking.configured?()
  end

  @doc """
  Run the wizard to configure the WiFi network

  Options:

  - `:run_ui` - if true this will run the UI after the wizard exits, if false
    this will do nothing after the wizard exits (default true).
  """
  @spec run_wizard([wizard_opt()]) :: :ok
  def run_wizard(opts \\ []) do
    case Keyword.get(opts, :run_ui, true) do
      true ->
        VintageNetWizard.run_wizard(on_exit: {__MODULE__, :start_ui, []})

      _ ->
        VintageNetWizard.run_wizard()
    end
  end

  @doc """
  Start the UI for the hello home application
  """
  @spec start_ui() :: :ok
  def start_ui() do
    case Application.ensure_all_started(:hello_home) do
      {:ok, _} ->
        :ok
    end
  end
end
