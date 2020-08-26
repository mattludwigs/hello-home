# HelloHomeFw

A prototype firmware for running HelloHome software on a Raspberry Pi3.

Hardware:
  - [Raspberry Pi 3](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/)
  - [Z-Wave Bridge Controller](https://www.digikey.com/product-detail/en/silicon-labs/SLUSB001A/336-5899-ND/9867108)
  - [zipgateway binary compiled for Nerves rpi3 system](https://www.silabs.com/products/development-tools/software/z-wave/controller-sdk/z-ip-gateway-sdk)

The zipgateway binary is expected to be placed in `rootfs_overlay/usr/sbin/` directory.

On first boot the hub will not be configured for WiFi so [vintage_net_wizard](https://github.com/nerves-networking/vintage_net_wizard) will
start up and you can access the wizard via connecting to the `nerves-*` (where
the `*` is the serial number used and is variable from hub to hub) access point
in your network manager interface of your OS.

After WiFi is configured the hub should start the HelloHome software and can be
accessed via ip address.