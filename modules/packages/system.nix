{ config, pkgs, lib, ... }:

{
  # This module configures System packages for NixOS.


  config = {


    # Install firefox.
    programs.firefox.enable = true;

    programs.nh = {
      enable = true;
      # Путь к твоей папке с конфигами (важно для работы из любого места)
      flake = "/home/xellor/nixos-config";
      # Автоматическая очистка каждую неделю
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      discord
    ];

  };
}
