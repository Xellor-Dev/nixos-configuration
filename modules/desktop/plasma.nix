{ config, pkgs, lib, ... }:

{
  # This module configures the KDE Plasma Desktop Environment for NixOS.


  config = {
    
  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;

  };
}