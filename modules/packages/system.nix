{ config, pkgs, lib, ... }:

{
  # This module configures System packages for NixOS.


  config = {


    # Install firefox.
    programs.firefox.enable = true;
    programs.hyprland.enable = true;
    programs.hyprland.withUWSM = true;
    programs.nh = {
      enable = true;
      flake = "/home/xellor/nixos-config";
      # Автоматическая очистка каждую неделю
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
    };

    hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    # Fish нужен на системном уровне, т.к. Hyprland exec не видит home-manager PATH
    programs.fish.enable = true;

    environment.systemPackages = with pkgs; [
      discord
      libxcb-cursor
      xorg.libXcursor
      kitty
      # foot — управляется caelestia-nixos через programs.foot (HM)
      # vscodium — управляется caelestia-nixos через editor.vscode (HM)
      thunar
      nemo
      # qps — пакет не существует в nixpkgs-unstable
      pavucontrol
      github-desktop
      # jq — управляется caelestia-nixos как зависимость
    ];

  };
}
