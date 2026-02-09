#
# home.nix — Home Manager configuration (modular integration)
#
# Architecture: caelestia-nixos is the single source of truth for Hyprland/shell/term/editor.
# This file contains ONLY:
#   1. caelestia-nixos module integration
#   2. Machine-specific overrides
#   3. Packages and programs NOT managed by caelestia
#
{ config, pkgs, inputs, lib, ... }:

{
  home.stateVersion = "23.11";

  # ── 1. Modules ────────────────────────────────────────────────────────
  # caelestia-nixos includes caelestia-shell internally (caelestia.nix:L11),
  # so we do NOT import caelestia-shell directly to avoid duplicate imports.
  imports = [
    inputs.caelestia-nix.homeManagerModules.default
  ];

  # ── 2. Caelestia Dots (declarative configuration) ─────────────────────
  # Enables ALL components: hyprland, foot, fish, starship, btop, vscode, shell, cli.
  # Each submodule can be disabled via .enable = false.
  programs.caelestia-dots = {
    enable = true;

    # ── Hyprland (managed by caelestia-nixos via wayland.windowManager.hyprland) ──
    # xdg.configFile."hypr" is NOT needed — config is generated declaratively.
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

    # ── Shell (AGS bar, launcher, notifications, etc.) ───────────────────
    caelestia.shell = {
      paths.wallpaperDir = "~/Pictures/Wallpapers";
      general.apps = {
        terminal = [ "foot" ];
        audio = [ "pavucontrol" ];
      };
    };

    # ── CLI (theme engine) ────────────────────────────────────────────────
    caelestia.cli.settings = {
      theme.enableGtk = false;
    };

    # ── Foot (terminal) — managed by caelestia, xdg.configFile not needed ─
    # foot.settings can be used to override font, size, etc. if needed.

    # ── Editor (vscode/vscodium) ──────────────────────────────────────────
    # editor.vscode is managed by caelestia-nixos, no need for system-wide vscodium.
  };

  # ── 3. Packages (ONLY those NOT managed by caelestia) ─────────────────
  # caelestia-nixos already installs/enables: foot, fish, starship, btop, vscode,
  # gnome-keyring, polkit-gnome, gammastep, cliphist, hyprpicker, trash-cli.
  home.packages = with pkgs; [
    git
    # Fonts
    nerd-fonts.jetbrains-mono
    font-awesome
    # Utilities (not managed by caelestia)
    kitty # Alternative terminal
    rofi
    swww
    fzf
    fastfetch
    tinymist
  ];

  # ── 5. ZSH (additional shell, does not conflict with caelestia's fish) ─
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Starship is managed by caelestia-nixos via term.starship — no duplication needed.
  # programs.starship.enable = true;  ← removed, caelestia enables with full config.

  # ── 6. Clean up conflicting files before Home Manager activation ─────────
  home.activation.cleanupConflictingFiles = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ~/.config/caelestia/shell.json.backup
    rm -f ~/.config/VSCodium/User/settings.json.backup
  '';

  # Make VSCodium settings.json writable (HM normally symlinks it read-only).
  home.activation.vscodiumWritableSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for settings_dir in \
      "$HOME/.config/VSCodium/User" \
      "$HOME/.config/.vscode-oss/User" \
      "$HOME/.config/Code/User"; do
      settings_file="$settings_dir/settings.json"

      if [ -L "$settings_file" ]; then
        tmp=$(mktemp)
        cp -L "$settings_file" "$tmp"
        rm -f "$settings_file"
        mkdir -p "$settings_dir"
        cp "$tmp" "$settings_file"
        chmod 644 "$settings_file"
        rm -f "$tmp"
      fi
    done
  '';
}
