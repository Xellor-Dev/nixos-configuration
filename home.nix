{ pkgs, inputs, ... }:

{
  # home manager programs
  home.packages = with pkgs; [
    inputs.caelestia-shell.packages.x86_64-linux.default
    git
  ];

  imports = [

  ];

  home.stateVersion = "23.11";

  programs.caelestia = {
    enable = true;
    systemd = {
      enable = false; # if you prefer starting from your compositor
      target = "graphical-session.target";
      environment = [ ];
    };
    settings = {
      bar.status = {
        showBattery = false;
      };
      paths.wallpaperDir = "~/Images";
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = false;
      };
    };
  };
}
