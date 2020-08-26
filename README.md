# HelloHome

This is an example of using the Elixir ecosystem to build a SmartHome controller in Elixir.

This illustrates using:

- Nerves
- Grizzly
- Phoenix
- PhoenixLiveView
- VintageNet
- VintageNetWizard


There are three projects:

- HelloHome - main UI software that the user interacts with.
- HelloHomeHub - main hub logic around network setup and running different OTP
  apps.
- HelloHomeFw - the Nerves firmware project that provides a runtime for the
  HelloHomeHub project.
