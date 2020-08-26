defmodule HelloHomeHub.Network do
  @doc """
  Initialize the implementation and pass any options to it that were given
  """
  @callback init(any()) :: any()

  @doc """
  Check if the network is configured
  """
  @callback configured?(any()) :: boolean()
end
