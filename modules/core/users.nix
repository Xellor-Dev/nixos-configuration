{ config, pkgs, lib, ... }:

{
  # This module configures User accounts for NixOS.


  config = {


    users.users.xellor = {
      isNormalUser = true;
      description = "Daniel";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        kdePackages.kate
        #  thunderbird
      ];
    };

  };
}
