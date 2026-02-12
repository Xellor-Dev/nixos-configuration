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
      ELECTRON_OZONE_PLATFORM_HINT = "wayland"; # Принудительно использовать Wayland вместо auto
      
      # Electron Wayland window decorations fix (для Electron 32+ resize bug)
      # Ref: https://bbs.archlinux.org/viewtopic.php?id=300635
      # Ref: https://bbs.archlinux.org/viewtopic.php?id=292623
      # Ref: https://github.com/electron/electron/issues/42894
      ELECTRON_ENABLE_FEATURES = "UseOzonePlatform,WaylandWindowDecorations";
      
      # NVIDIA Wayland fixes
      WLR_NO_HARDWARE_CURSORS = "1"; # Фикс курсора на NVIDIA
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
    };
  };
}
