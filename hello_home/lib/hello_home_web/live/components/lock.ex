defmodule HelloHomeWeb.Live.Components.Lock do
  @moduledoc """
  A `Phoenix.LiveView` component for a lock
  """
  use HelloHomeWeb, :live_component

  @type state() :: :unsecured | :secured | :unknown

  @type mode() :: :unsecured | :secured | :refresh

  # Phoenix.LiveComponent implementation

  @impl Phoenix.LiveComponent
  def update(assigns, socket) do
    case HelloHome.get_state(assigns.device) do
      {:ok, state} ->
        {:ok,
         socket
         |> assign(assigns)
         |> assign(:state, state)}

      {:error, :timeout} ->
        {:ok, socket |> assign(:state, :unknown)}
    end
  end

  @impl Phoenix.LiveComponent
  def handle_event("run_lock_action", _, socket) do
    case get_next_mode(socket.assigns.state) do
      :refresh ->
        try_refresh(socket)

      next_mode ->
        run_next_mode(socket, next_mode)
    end
  end

  # View functions

  @doc """
  Make the state name into a string
  """
  @spec state_to_string(state()) :: String.t()
  def state_to_string(:secured), do: "Locked"
  def state_to_string(:unsecured), do: "Unlocked"
  def state_to_string(:unknown), do: "Refresh Page"

  # Private functions

  defp get_next_mode(:secured), do: :unsecured
  defp get_next_mode(:unsecured), do: :secured
  defp get_next_mode(:unknown), do: :refresh

  defp run_next_mode(socket, next_mode) do
    case HelloHome.set_state(socket.assigns.device, next_mode) do
      :ok ->
        {:noreply, socket |> assign(:state, next_mode)}

      _ ->
        {:noreply, socket}
    end
  end

  defp try_refresh(socket) do
    case HelloHome.get_state(socket.assigns.device) do
      {:ok, state} ->
        {:noreply,
         socket
         |> assign(:state, state)}

      {:error, :timeout} ->
        {:noreply, socket}
    end
  end
end
