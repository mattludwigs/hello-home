defmodule HelloHomeWeb.DeviceLive.Index do
  use HelloHomeWeb, :live_view

  alias HelloHomeWeb.Live.Components

  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _sessions, socket) do
    device_id = String.to_integer(id)

    {:ok,
     socket
     |> assign(:device, HelloHome.device(device_id))}
  end

  def render_device_component(socket, device) do
    case device.type do
      :lock ->
        live_component(socket, Components.Lock, id: device.id, device: device)

      :notification_sensor ->
        live_component(socket, Components.NotificationSensor, device: device)

      :controller ->
        live_component(socket, Components.Controller, device: device)

      :switch_binary ->
        live_component(socket, Components.SwitchBinary, id: device.id, device: device)
    end
  end

  def type_as_title(device) do
    device.type
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end
end
