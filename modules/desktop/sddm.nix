# SDDM отключён для перехода на noctalia-shell
# { config, pkgs, lib, ... }:
# {
#   # This module configures SDDM Display Manager for NixOS.
#   config = {
#     services.displayManager.sddm.wayland.enable = true;
#   };
# }
