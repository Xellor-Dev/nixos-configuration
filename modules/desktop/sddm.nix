{ config, pkgs, lib, ... }:

{
  # This module configures SDDM Display Manager for NixOS.


  config = {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
  };
}
