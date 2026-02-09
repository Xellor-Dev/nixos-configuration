{ config, pkgs, ... }:

{
  # This module configures gaming packages and settings for NixOS.

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

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
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Performance mode enabled' && echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Returning to powersave' && echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    protonup-qt
    gamescope
    mangohud
    libnotify
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  powerManagement.cpuFreqGovernor = "schedutil";
}
