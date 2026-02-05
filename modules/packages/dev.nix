{ config, pkgs, lib, ... }:

{
  # This module configures Development packages for NixOS.


  config = {

  environment.systemPackages = with pkgs; [

  vscode
  git
  gh
  nodejs
  curl
  ];

  };
}