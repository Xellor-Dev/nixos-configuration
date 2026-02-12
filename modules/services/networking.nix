{ config, pkgs, lib, ... }:

{
  # This module configures networking settings for NixOS.

  config = {
    # Hostname and basic networking
    networking.hostName = "nixos";
    networking.networkmanager.enable = true;
    
    # Автоподключение к сети при загрузке
    systemd.services.NetworkManager-wait-online = {
      enable = true;
      wantedBy = [ "network-online.target" ];
    };
    
    # Дополнительные настройки NetworkManager для стабильности
    networking.networkmanager.wifi.powersave = false; # Отключить энергосбережение WiFi
  };
}
