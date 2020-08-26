defmodule HelloHomeHub.Networking do
  @moduledoc false

  use GenServer

  @spec start_link(module()) :: GenServer.on_start()
  def start_link(impl) do
    GenServer.start_link(__MODULE__, impl, name: __MODULE__)
  end

  @spec configured?() :: boolean()
  def configured?() do
    GenServer.call(__MODULE__, :configured?)
  end

  @impl GenServer
  def init(impl) do
    {impl, impl_opts} = format_impl(impl)
    impl_state = impl.init(impl_opts)

    {:ok, %{impl: impl, impl_state: impl_state}}
  end

  @impl GenServer
  def handle_call(:configured?, _from, state) do
    %{impl: impl, impl_state: impl_state} = state

    {:reply, impl.configured?(impl_state), state}
  end

  defp format_impl({_, _} = impl), do: impl
  defp format_impl(impl) when is_atom(impl), do: {impl, []}
end
