{ config, pkgs, lib, ... }:

{
  # This module configures Boot settings for NixOS.

  config = {

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

  };
}
