{ config, pkgs, lib, ... }:

{
  # This module configures the KDE Plasma Desktop Environment for NixOS.


  config = {

    # Enable the KDE Plasma Desktop Environment.
    # services.desktopManager.plasma6.enable = false;

    # # Disable automatic suspend/poweroff when idle
    # services.logind.lidSwitch = "ignore";
    # services.logind.settings.Login = {
    #   HandlePowerKey = "ignore";
    #   IdleAction = "ignore";
    # };

    # # Disable X11 screen blanking and DPMS
    # services.xserver.displayManager.sessionCommands = ''
    #   xset s off
    #   xset -dpms
    #   xset s noblank
    # '';

  };
}
