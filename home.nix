{ pkgs, inputs, ... }:

{
  home.stateVersion = "23.11";

  # 1. Импортируем модуль шелла
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    git
    # Шрифты
    nerd-fonts.jetbrains-mono
    font-awesome
    # Утилиты
    kitty
    rofi
    swww
    foot
    fzf
    starship
    fastfetch
    # Зависимости caelestia-dots (отсутствуют в NixOS по умолчанию)
    gnome-keyring
    polkit_gnome
    gammastep
    trash-cli
    hyprpicker
    jq
  ];

  # 2. Раскладка (для Home Manager сессии)
  home.keyboard = {
    layout = "us,ru";
    options = [ "grp:alt_shift_toggle" ];
  };

  # 3. Настройки Caelestia Shell через встроенный модуль
  programs.caelestia = {
    enable = true;

    cli = {
      enable = true;
      settings = {
        theme.enableGtk = false;
      };
    };

    # Включаем systemd сервис для автозапуска
    systemd.enable = true;

    settings = {
      bar.enable = true;
      
      # Пути к обоям и другим ресурсам
      paths = {
        wallpaperDir = "~/Pictures/Wallpapers";
      };

      # Приложения по умолчанию
      general.apps = {
        terminal = ["foot"];
        audio = ["pavucontrol"];
      };
    };
  };

  # 4. Конфиги из caelestia-dots
  xdg.configFile = {
    # Копируем все конфиги hypr из caelestia-dots
    "hypr" = {
      source = "${inputs.caelestia-dots}/hypr";
      recursive = true;
    };
    "foot" = {
      source = "${inputs.caelestia-dots}/foot";
      recursive = true;
    };
    "fish" = {
      source = "${inputs.caelestia-dots}/fish";
      recursive = true;
    };
  };

  # 5. Фиксы для NixOS (пути отличаются от Arch)
  xdg.configFile."caelestia/hypr-user.conf" = {
    force = true;
    text = ''
      # Переопределяем exec-once с правильными путями для NixOS
      # (execs.conf из caelestia-dots использует /usr/lib/ пути от Arch)
      exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1

      # Раскладка клавиатуры
      input {
        kb_layout = us,ru
        kb_options = grp:alt_shift_toggle
      }
    '';
  };

  # 6. ZSH
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.starship.enable = true;
}
