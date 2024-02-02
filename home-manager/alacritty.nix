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
          background = "#${config.colorScheme.palette.base00}";
          foreground = "#${config.colorScheme.palette.base05}";
        };

        normal = {
          black = "#${config.colorScheme.palette.base00}";
          red = "#${config.colorScheme.palette.base08}";
          green = "#${config.colorScheme.palette.base0B}";
          yellow = "#${config.colorScheme.palette.base0A}";
          blue = "#${config.colorScheme.palette.base0D}";
          magenta = "#${config.colorScheme.palette.base0E}";
          cyan = "#${config.colorScheme.palette.base0C}";
          white = "#${config.colorScheme.palette.base05}";

        };
      };
    };
  };
}
