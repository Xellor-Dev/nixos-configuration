{ config, pkgs, lib, ... }:

{
  # This module configures Development packages for NixOS.


  config = {

    environment.systemPackages = with pkgs; [

      git
      gh
      nodejs
      curl
      just
      nixpkgs-fmt
      nix-output-monitor
      vmtouch
    ];

  };
}
