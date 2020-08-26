defmodule HelloHome.ZWave.InclusionHandler do
  @moduledoc false

  @behaviour Grizzly.InclusionHandler
  require Logger

  alias Grizzly.Inclusions
  alias Grizzly.ZWave.Command

  @impl Grizzly.InclusionHandler
  def handle_report(report, _) do
    case report.command.name do
      :node_remove_status ->
        Phoenix.PubSub.broadcast(
          HelloHome.PubSub,
          "inclusions",
          {:device_removed, Command.param!(report.command, :node_id)}
        )

        :ok

      :node_add_status ->
        handle_node_add_status(report)

      :node_add_keys_report ->
        requested_keys = Command.param!(report.command, :requested_keys)
        Inclusions.grant_keys(requested_keys)

        :ok

      :node_add_dsk_report ->
        Phoenix.PubSub.broadcast(
          HelloHome.PubSub,
          "inclusions",
          :input_dsk_request
        )

        :ok
    end
  end

  @impl Grizzly.InclusionHandler
  def handle_timeout(something, _) do
    Logger.warn("Timeout: #{inspect(something)}")
  end

  defp handle_node_add_status(report) do
    node_id = Command.param!(report.command, :node_id)
    Phoenix.PubSub.broadcast(HelloHome.PubSub, "inclusions", {:device_added, node_id})
  end
end
