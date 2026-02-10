{ config, pkgs, inputs, lib, ... }:

let
  # Discord wrapper with Wayland and GPU optimization flags
  discord-wayland = pkgs.symlinkJoin {
    name = "discord";
    paths = [ pkgs.discord ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/discord \
        --add-flags "--enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer" \
        --add-flags "--ozone-platform=wayland" \
        --add-flags "--enable-gpu-rasterization" \
        --add-flags "--enable-zero-copy" \
        --add-flags "--ignore-gpu-blocklist" \
        --add-flags "--enable-hardware-overlays" \
        --add-flags "--enable-smooth-scrolling"
    '';
  };
in

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

    # Prevent auto-focus on floating windows
    hypr.hyprland.misc.settings.misc = {
      focus_on_activate = false; # Don't auto-focus windows that request activation
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
    nerd-fonts.jetbrains-mono
    font-awesome
    kitty
    rofi
    swww
    fzf
    fastfetch
    tinymist
    discord-wayland
    webcord
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
