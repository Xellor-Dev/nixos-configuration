{ config, pkgs, ... }:

{
  # This module configures gaming packages and settings for NixOS.

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;

    # Enable Gamescope session for Steam games
    gamescopeSession.enable = true;
  };

  # Enable GameMode for performance optimization
  programs.gamemode.enable = true;

  # Додаткові пакети для ігор
  environment.systemPackages = with pkgs; [
    # Proton/Wine залежності
    protonup-qt

    # Gamescope для правильної роздільної здатності
    gamescope

  ];

  # Enable 32-bit graphics drivers for gaming compatibility
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
