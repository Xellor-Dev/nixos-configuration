{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/desktop/noctalia.nix
    ];

  # Optional: Set NIX_PATH so legacy tools can find your config
  nix.nixPath = [ "nixos-config=/home/xellor/nixos-config/configuration.nix" ];
}
