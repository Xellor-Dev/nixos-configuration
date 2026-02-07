#
# home.nix — Конфигурация Home Manager (Вариант B: модульная интеграция)
#
# Принцип: caelestia-nixos — единственный источник правды для Hyprland/shell/term/editor.
# Этот файл содержит ТОЛЬКО:
#   1. Подключение caelestia-nixos модуля
#   2. Переопределения специфичные для ВАШЕЙ машины
#   3. Пакеты и программы, НЕ управляемые caelestia
#
{ pkgs, inputs, ... }:

{
  home.stateVersion = "23.11";

  # ── 1. Модули ─────────────────────────────────────────────────────────
  # caelestia-nixos подключает caelestia-shell внутри себя (caelestia.nix:L11),
  # поэтому НЕ импортируем caelestia-shell напрямую — избегаем двойного импорта.
  imports = [
    inputs.caelestia-nix.homeManagerModules.default
  ];

  # ── 2. Caelestia Dots (декларативное управление) ──────────────────────
  # Включает ВСЁ: hyprland, foot, fish, starship, btop, vscode, shell, cli.
  # Каждый субмодуль можно отключить через .enable = false.
  programs.caelestia-dots = {
    enable = true;

    # ── Hyprland (caelestia-nixos управляет wayland.windowManager.hyprland) ──
    # НЕ нужен xdg.configFile."hypr" — конфиг генерируется декларативно.
    hypr.variables = {
      terminal = "foot";
      browser = "firefox";
      editor = "codium";
      fileExplorer = "thunar";
      cursorTheme = "Sweet-cursors";
      cursorSize = 24;
    };

    # Кастомные keybinds для раскладки (вместо ручного hypr-user.conf)
    hypr.hyprland.input.settings.input = {
      kb_layout = "us,ru";
      kb_options = "grp:alt_shift_toggle";
    };

    # ── Shell (AGS bar, launcher, notifications, etc.) ──────────────────
    caelestia.shell = {
      paths.wallpaperDir = "~/Pictures/Wallpapers";
      general.apps = {
        terminal = [ "foot" ];
        audio = [ "pavucontrol" ];
      };
    };

    # ── CLI (theme engine) ──────────────────────────────────────────────
    caelestia.cli.settings = {
      theme.enableGtk = false;
    };

    # ── Foot (терминал) — управляется caelestia, не нужен xdg.configFile ──
    # foot.settings — при необходимости переопределить шрифт, размер и т.д.

    # ── Editor (vscode/vscodium) ────────────────────────────────────────
    # editor.vscode управляется caelestia-nixos, не ставим vscodium системно.
  };

  # ── 3. Пакеты (ТОЛЬКО те, которые НЕ управляются caelestia) ──────────
  # caelestia-nixos уже ставит/включает: foot, fish, starship, btop, vscode,
  # gnome-keyring, polkit-gnome, gammastep, cliphist, hyprpicker, trash-cli.
  home.packages = with pkgs; [
    git
    # Шрифты
    nerd-fonts.jetbrains-mono
    font-awesome
    # Утилиты (не управляемые caelestia)
    kitty        # Альтернативный терминал
    rofi
    swww
    fzf
    fastfetch
  ];

  # ── 4. Раскладка ─────────────────────────────────────────────────────
  home.keyboard = {
    layout = "us,ru";
    options = [ "grp:alt_shift_toggle" ];
  };

  # ── 5. ZSH (ваш дополнительный шелл, не конфликтует с fish от caelestia) ─
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Starship управляется caelestia-nixos через term.starship — не дублируем.
  # programs.starship.enable = true;  ← убрано, caelestia включает с полным конфигом.
}
