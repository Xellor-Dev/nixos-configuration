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
  programs.gamemode = {
    enable = true;
    enableRenice = true; # Allow renice for better priority

    settings = {
      general = {
        renice = 10; # Process priority boost
        softrealtime = "auto"; # Soft realtime scheduling
        inhibit_screensaver = 1; # Prevent screensaver during gaming
      };

      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0; # NVIDIA RTX 3060 Ti
        nv_powermizer_mode = 1; # Prefer maximum performance
      };

      cpu = {
        # Intel i5-11400F optimization
        park_cores = "no";
        pin_cores = "yes";
      };

      custom = {
        # Switch to performance governor when gaming
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Performance mode enabled' && echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Returning to powersave' && echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor";
      };
    };
  };

  # Gaming packages
  environment.systemPackages = with pkgs; [
    # Proton/Wine dependencies
    protonup-qt

    # Gamescope for proper resolution handling
    gamescope

    # Performance monitoring
    mangohud # FPS overlay
    libnotify # Notifications for gamemode
  ];

  # Enable 32-bit graphics drivers for gaming compatibility
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # CPU frequency scaling for gaming
  powerManagement.cpuFreqGovernor = "schedutil"; # Auto-scale, switches to performance when needed
}
