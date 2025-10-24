{ config, lib, pkgs, ... }:

{
  gtk = {
    enable = true;
    font = {
      name = "Mononoki Nerd Font";
      package = null;
      size = 12;
    };
    #iconTheme = {
    # name = "Gruvbox-Plus-Icons";
    #      name = "Papirus-Dark";
    #      package = pkgs.papirus-icon-theme;
    #package = pkgs.gruvbox-plus-icons;
    #};
    theme = {
      #      name = "Nordic";
      name = "Gruvbox GTK Themes";
      #name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.gruvbox-gtk-theme;
      #      package = pkgs.nordic;
      #  pkgs.catppuccin-gtk.override {
      #   accents = [ "mauve" ];
      #   variant = "mocha";
      # };
    };

    # gtk2.extraConfig = {
    #  gtk-application-prefer-dark-theme = 1;
    # gtk-im-module = "fcitx";
    #};
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      #gtk-im-module = "fcitx";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      #gtk-im-module = "fcitx";
    };
  };

  # Theme QT -> GTK
  # qt = {
  #   enable = true;
  #   platformTheme.name = "gtk";
  #   style = {
  #     name = "adwaita-dark";
  #     package = pkgs.adwaita-qt;
  #   };
  # };

}
