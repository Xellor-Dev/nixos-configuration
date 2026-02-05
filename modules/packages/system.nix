{ config, pkgs, lib, ... }:

{
  # This module configures System packages for NixOS.


  config = {


    # Install firefox.
    programs.firefox.enable = true;

    programs.nh = {
      enable = true;
      flake = "/home/xellor/nixos-config";
      # Автоматическая очистка каждую неделю
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
    };


    programs.starship = {
      enable = true;
      # Configuration written to ~/.config/starship.toml
      settings = {
        # add_newline = false;

        # character = {
        #   success_symbol = "[➜](bold green)";
        #   error_symbol = "[➜](bold red)";
        # };

        # package.disabled = true;
      };
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
