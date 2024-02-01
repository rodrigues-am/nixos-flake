{ config, lib, pkgs, ... }: {

  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    settings = {
      scrolling = { history = 10000; };

      window = {
        dynamic_padding = true;
        opacity = 0.98;
        padding = {
          x = 10;
          y = 10;
        };
      };

      font = {
        size = 12;
        normal = {
          family = "Fira Code";
          style = "Regular";
        };
        bold = {
          family = "Fira Code";
          style = "Bold";
        };
        italic = {
          family = "Fira Code";
          style = "Italic";
        };
        bold_italic = {
          family = "Fira Code";
          style = "Bold Italic";
        };
      };

      colors = {

        primary = {
          background = "#${config.colorScheme.colors.base00}";
          foreground = "#${config.colorScheme.colors.base05}";
        };

        normal = {
          black = "#${config.colorScheme.colors.base00}";
          red = "#${config.colorScheme.colors.base08}";
          green = "#${config.colorScheme.colors.base0B}";
          yellow = "#${config.colorScheme.colors.base0A}";
          blue = "#${config.colorScheme.colors.base0D}";
          magenta = "#${config.colorScheme.colors.base0E}";
          cyan = "#${config.colorScheme.colors.base0C}";
          white = "#${config.colorScheme.colors.base05}";

        };
      };
    };
  };
}
