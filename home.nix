{ pkgs, inputs, ... }:

{
  # home manager programs
  home.packages = with pkgs; [
  ];

  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.stateVersion = "23.11";

  programs.noctalia-shell = {
    enable = true;
    settings = {
      key = "value";
    };
    colors = {
      mError = "#dddddd";
      mOnError = "#111111";
      mOnPrimary = "#111111";
      mOnSecondary = "#111111";
      mOnSurface = "#828282";
      mOnSurfaceVariant = "#5d5d5d";
      mOnTertiary = "#111111";
      mOutline = "#3c3c3c";
      mPrimary = "#aaaaaa";
      mSecondary = "#a7a7a7";
      mShadow = "#000000";
      mSurface = "#111111";
      mSurfaceVariant = "#191919";
      mTertiary = "#cccccc";
    };
    "user-templates" = {
      templates = {
        neovim = {
          input_path = "~/.config/noctalia/templates/template.lua";
          output_path = "~/.config/nvim/generated.lua";
          post_hook = "pkill -SIGUSR1 nvim";
        };
      };
    };
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        catwalk = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 1;
    };
    pluginSettings = {
      wallpaper = {
        blur = true;
        path = "/path/to/your/wallpaper.png"; # Please change this
      };
    };
  };
}
