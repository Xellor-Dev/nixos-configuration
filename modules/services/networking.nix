{ config, pkgs, lib, ... }:

{
  # This module configures networking settings for NixOS.

  config = {
    # Hostname and basic networking
    networking.hostName = "nixos";
    networking.networkmanager.enable = true;
  };
}
