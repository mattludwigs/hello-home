defmodule HelloHome do
  @moduledoc """
  API for controlling `HelloHome` devices
  """

  alias HelloHome.{Device, ZWave}

  @doc """
  Get all the devices
  """
  @spec devices() :: [Device.t()]
  def devices() do
    ZWave.devices()
  end

  @doc """
  Get a device
  """
  @spec device(Device.id()) :: Device.t() | nil
  def device(device_id) do
    ZWave.device(device_id)
  end

  @doc """
  Get the state of a device
  """
  @spec get_state(Device.t()) :: {:ok, any()} | {:error, any()}
  def get_state(device) do
    ZWave.get_state(device)
  end

  @doc """
  Set the state of a device
  """
  @spec set_state(Device.t(), any()) :: :ok | {:error, any()}
  def set_state(device, value) do
    ZWave.set_state(device, value)
  end

  @doc """
  Start the process of removing a device
  """
  @spec remove_device() :: :ok
  def remove_device() do
    ZWave.remove_device()
  end

  @doc """
  Start the process of adding a device
  """
  @spec add_device() :: :ok
  def add_device() do
    ZWave.add_device()
  end

  @doc """
  Enable the process by which a device and push notifications
  to the system
  """
  @spec enable_notifications(Device.id()) :: :ok | :error
  def enable_notifications(device_id) do
    ZWave.receive_notifications(device_id)
  end
end
