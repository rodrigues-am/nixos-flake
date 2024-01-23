{ config, lib, pkgs, userSettings, nix-doom-emacs, nix-colors, ... }:

{
  imports = [
    ./bash.nix
    ./git.nix
    ./starship.nix
    ./gtk.nix
    ./brave.nix
    ./doom.nix
    ./xcompose.nix
    ./waybar.nix
    ./rofi.nix
    ./swaylock.nix
    ./swaync.nix
    ./hyprland.nix
    ./syncthing.nix
    ./espanso.nix

    # pkgs
    ./pkgs-hyprland.nix
    ./pkgs-program.nix
    ./pkgs-fonts.nix
    ./pkgs-general.nix

    # scripts
    ./bin/doomcapture.nix
    ./bin/emopicker9000.nix
    #./bin/wallsetter.nix
    #./bin/themechange.nix
    #./bin/theme-selector.nix

    nix-colors.homeManagerModules.default
    nix-doom-emacs.hmModule
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${userSettings.name}";
  home.homeDirectory = "/home/${userSettings.name}";

  colorScheme = nix-colors.colorSchemes.nord;

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [ ];

  home.file = {
    # alacritty
    ".config/alacritty.toml".source = ./alacritty.toml;
  };

  home.sessionVariables = {
    EDITOR = "${userSettings.editor}";
    TERM = "${userSettings.term}";
    BROWSER = "${userSettings.browser}";
    GTK_IM_MODULE = "cedilla";
    QT_IM_MODULE = "cedilla";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
