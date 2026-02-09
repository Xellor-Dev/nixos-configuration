{ config, pkgs, inputs, lib, ... }:

{
  home.stateVersion = "23.11";

  imports = [
    inputs.caelestia-nix.homeManagerModules.default
  ];

  programs.caelestia-dots = {
    enable = true;

    hypr.variables = {
      terminal = "foot";
      browser = "firefox";
      editor = "codium";
      fileExplorer = "thunar";
      cursorTheme = "Sweet-cursors";
      cursorSize = 24;
    };

    # Custom keybinds for keyboard layout (replaces manual hypr-user.conf)
    hypr.hyprland.input.settings.input = {
      kb_layout = "us,ru,ua";
      kb_options = "grp:alt_shift_toggle";
    };

    caelestia.shell = {
      paths.wallpaperDir = "~/Pictures/Wallpapers";
      general.apps = {
        terminal = [ "foot" ];
        audio = [ "pavucontrol" ];
      };
    };

    caelestia.cli.settings = {
      theme.enableGtk = false;
    };

  };

  home.packages = with pkgs; [
    git
    nerd-fonts.jetbrains-mono
    font-awesome
    kitty
    rofi
    swww
    fzf
    fastfetch
    tinymist
    discord
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  home.activation.cleanupConflictingFiles = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ~/.config/caelestia/shell.json.backup
  '';
}
