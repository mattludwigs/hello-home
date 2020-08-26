defmodule HelloHomeWeb.Live.Components.SwitchBinary do
  use HelloHomeWeb, :live_component

  @impl Phoenix.LiveComponent
  def update(assigns, socket) do
    {:ok, state} = HelloHome.get_state(assigns.device)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:state, state)}
  end

  @impl Phoenix.LiveComponent
  def handle_event("switch_state", _, socket) do
    next_state = next_state(socket.assigns.state)

    :ok = HelloHome.set_state(socket.assigns.device, next_state)

    {:noreply,
     socket
     |> assign(:state, next_state)}
  end

  def display_state_name(:off), do: "Off"
  def display_state_name(:on), do: "On"

  def next_state(:off), do: :on
  def next_state(:on), do: :off
end
