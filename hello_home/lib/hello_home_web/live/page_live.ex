defmodule HelloHomeWeb.PageLive do
  use HelloHomeWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()

    devices = HelloHome.devices()
    {:ok, socket |> assign(:devices, devices) |> assign(:get_dsk, false)}
  end

  @impl Phoenix.LiveView
  def handle_event("remove_device", _, socket) do
    case HelloHome.remove_device() do
      :ok ->
        {:noreply, put_flash(socket, :info, "Controller ready to remove the device")}
    end
  end

  def handle_event("add_device", _, socket) do
    case HelloHome.add_device() do
      :ok ->
        {:noreply, put_flash(socket, :info, "Controller ready to add a device")}
    end
  end

  def handle_event("save_input_dsk", %{"input_dsk" => %{"input_dsk" => dsk}}, socket) do
    dsk = String.to_integer(dsk)
    Grizzly.Inclusions.set_input_dsk(dsk)

    {:noreply, socket |> assign(:get_dsk, false)}
  end

  @impl Phoenix.LiveView
  def handle_info({:device_removed, device_id}, socket) do
    devices = HelloHome.devices()

    {:noreply,
     socket
     |> assign(:devices, devices)
     |> put_flash(:info, "Device #{inspect(device_id)} removed")}
  end

  def handle_info({:device_added, device_id}, socket) do
    devices = HelloHome.devices()

    case HelloHome.enable_notifications(device_id) do
      :ok ->
        {:noreply,
         socket
         |> assign(:devices, devices)
         |> put_flash(:info, "Device #{inspect(device_id)} added and configured!!")}

      _ ->
        {:noreply,
         socket
         |> assign(:devices, devices)
         |> put_flash(
           :info,
           "Device #{inspect(device_id)} added, but not enabled notifications!!"
         )}
    end
  end

  def handle_info(:input_dsk_request, socket) do
    {:noreply,
     socket
     |> assign(:get_dsk, true)
     |> put_flash(:info, "Please enter device DSK to complete inclusion")}
  end

  defp subscribe() do
    Phoenix.PubSub.subscribe(HelloHome.PubSub, "inclusions")
  end
end
