{ config, pkgs, lib, ... }:

{
  # This module configures graphics settings

  config = {

    hardware.graphics = {
      enable = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {

      # Modesetting is required.
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    environment.sessionVariables = {
      # Electron/Chromium Wayland support
      NIXOS_OZONE_WL = "1"; # Включает Wayland для Electron/Chromium (работает с NixOS 25.05+)
      ELECTRON_OZONE_PLATFORM_HINT = "auto"; # Electron 28-37 fallback для auto-detection Wayland
      
      # NVIDIA Wayland fixes
      WLR_NO_HARDWARE_CURSORS = "1"; # Фикс курсора на NVIDIA
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
    };
  };
}
