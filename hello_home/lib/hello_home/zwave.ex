defmodule HelloHome.ZWave do
  @moduledoc false

  ## internal Z-Wave wrapper so when there are changes to
  ## the Z-wave library it does not effect other parts of the
  ## code.

  alias HelloHome.Device
  alias Grizzly.{Inclusions, Network, Node, Report}
  alias Grizzly.ZWave.Command

  @doc """
  Get all the devices on teh Z-Wave network
  """
  @spec devices() :: [Device.t()]
  def devices() do
    case Network.get_node_ids() do
      {:ok, %Report{type: :command} = report} ->
        node_ids = Command.param!(report.command, :node_ids)

        Enum.reduce(node_ids, [], fn node_id, devices ->
          case device(node_id) do
            nil ->
              devices

            device ->
              [device | devices]
          end
        end)
        |> Enum.reverse()
    end
  end

  @doc """
  Get the device form the Z-Wave network
  """
  @spec device(Device.id()) :: Device.t() | nil
  def device(device_id) do
    case Node.get_info(device_id) do
      {:ok, %Report{type: :command} = report} ->
        make_device_from_node_info(report.command, device_id)

      # probably should handle this in a real application
      _other ->
        nil
    end
  end

  @spec send_command(Device.id(), {:get_state, Device.type()}) :: {:ok, any()}
  def send_command(device_id, {:get_state, :lock}) do
    case Grizzly.send_command(device_id, :door_lock_operation_get) do
      {:ok, %Report{type: :command} = report} ->
        {:ok, Command.param!(report.command, :mode)}
    end
  end

  @spec get_state(Device.t()) :: {:ok, any()} | {:error, any()}
  def get_state(device) do
    case device.type do
      :lock ->
        run_get_state_lock(device)

      :switch_binary ->
        run_get_state_switch_binary(device)
    end
  end

  @spec set_state(Device.t(), any()) :: :ok | {:error, any()}
  def set_state(device, value) do
    case device.type do
      :lock ->
        run_set_state_lock(device, value)

      :switch_binary ->
        run_set_state_switch_binary(device, value)
    end
  end

  @spec remove_device() :: :ok
  def remove_device() do
    Inclusions.remove_node()
  end

  @spec add_device() :: :ok
  def add_device() do
    Inclusions.add_node()
  end

  @doc """
  Enable notifications for the device by it's id
  """
  @spec receive_notifications(Device.id()) :: :ok | :error
  def receive_notifications(node_id) do
    case Node.set_lifeline_association(node_id) do
      ## handle more cases in real life
      {:ok, %Report{type: :ack_response}} ->
        :ok

      _ ->
        :error
    end
  end

  defp run_get_state_lock(device) do
    case send_command_expect_command(device.id, :door_lock_operation_get) do
      {:ok, report} ->
        {:ok, Command.param!(report.command, :mode)}

      {:error, _reason} = error ->
        error
    end
  end

  defp run_set_state_lock(device, value) do
    send_command_expect_ack_response(device.id, :door_lock_operation_set, mode: value)
  end

  defp run_get_state_switch_binary(device) do
    case send_command_expect_command(device.id, :switch_binary_get) do
      {:ok, report} ->
        {:ok, Command.param!(report.command, :target_value)}

      {:error, _reason} = error ->
        error
    end
  end

  defp run_set_state_switch_binary(device, value) do
    send_command_expect_ack_response(device.id, :switch_binary_set, target_value: value)
  end

  defp send_command_expect_command(device_id, command) do
    case Grizzly.send_command(device_id, command) do
      {:ok, %Report{type: :command} = report} ->
        {:ok, report}

      {:error, _reason} = error ->
        error
    end
  end

  defp send_command_expect_ack_response(device_id, command, command_args) do
    case Grizzly.send_command(device_id, command, command_args) do
      {:ok, %Report{type: :ack_response}} -> :ok
      {:error, _reason} = error -> error
    end
  end

  defp make_device_from_node_info(node_info, device_id) do
    %Device{
      id: device_id,
      type:
        device_type_from_device_classes(
          Command.param!(node_info, :generic_device_class),
          Command.param!(node_info, :specific_device_class)
        )
    }
  end

  defp device_type_from_device_classes(:static_controller, _), do: :controller
  defp device_type_from_device_classes(:entry_control, _), do: :lock

  defp device_type_from_device_classes(:sensor_notification, :notification_sensor),
    do: :notification_sensor

  defp device_type_from_device_classes(:switch_binary, :power_switch_binary), do: :switch_binary
end
