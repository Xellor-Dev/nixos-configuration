{ config, pkgs, ... }:

{
  # This module configures gaming packages and settings for NixOS.

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;

    # Extra packages for game compatibility and Gamescope
    package = pkgs.steam.override {
      extraPkgs = pkgs': with pkgs'; [
        # Xorg libraries for Gamescope
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver

        # Common game dependencies
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib # libstdc++.so.6
        libkrb5
        keyutils

        # Additional compatibility libraries
        gperftools # For some games' performance
      ];
    };

    # Wayland environment variables for better compatibility
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # Environment variables for Steam on Wayland/Hyprland
  environment.sessionVariables = {
    # Force Steam to use Wayland when possible
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";

    # Fix for some games on Wayland
    SDL_VIDEODRIVER = "x11"; # Fallback to X11 for game compatibility
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
    # Proton and compatibility tools
    protonup-qt

    # Gaming utilities
    gamescope
    mangohud # FPS overlay and monitoring
    goverlay # GUI for MangoHud configuration
    libnotify

    # Additional gaming tools
    steam-run # Run non-Steam games
    gamemode # Already enabled via programs.gamemode

    # Performance monitoring
    htop
    nvtopPackages.full # GPU monitoring for NVIDIA
  ];

  # Fonts for Steam UI and games
  fonts.packages = with pkgs; [
    liberation_ttf # Fallback fonts
    source-sans-pro # Steam UI font
    source-serif-pro
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  powerManagement.cpuFreqGovernor = "schedutil";
}
