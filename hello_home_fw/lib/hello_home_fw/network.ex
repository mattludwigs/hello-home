defmodule HelloHomeFw.Network do
  @behaviour HelloHomeHub.Network

  @impl HelloHomeHub.Network
  def init(opts) do
    opts
  end

  @impl HelloHomeHub.Network
  def configured?(_) do
    case VintageNet.get(["connection"]) do
      conn when conn in [:internet, :lan] ->
        true

      _ ->
        check_config()
    end
  end

  def check_config() do
    case VintageNet.get_configuration("wlan0") do
      %{type: VintageNetWiFi, vintage_net_wifi: wifi_config} ->
        !Enum.empty?(wifi_config.networks)

      _ ->
        false
    end
  end
end
