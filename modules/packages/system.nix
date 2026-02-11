{ config, pkgs, lib, ... }:

{
  # This module configures System packages for NixOS.


  config = {

    programs.firefox.enable = true;
    programs.hyprland.enable = true;
    programs.hyprland.withUWSM = true;
    programs.nh = {
      enable = true;
      flake = "/home/xellor/nixos-config";
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

    programs.fish.enable = true;

    environment.systemPackages = with pkgs; [
      libxcb-cursor
      xorg.libXcursor
      thunar
      nemo
      pavucontrol
      equibop
    ];

  };
}
