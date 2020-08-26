defmodule HelloHome.Device do
  @moduledoc """
  A structure for a device
  """

  @type t() :: %__MODULE__{
          id: id(),
          type: type()
        }

  @type type() :: :controller | :lock | :notification_sensor | :switch_binary

  @type id() :: non_neg_integer()

  defstruct id: nil, type: nil

  @doc """
  Create a `HelloHome.Device.t()` from a device id and the device type
  """
  @spec new(id(), type()) :: t()
  def new(id, type) do
    %__MODULE__{
      id: id,
      type: type
    }
  end
end
