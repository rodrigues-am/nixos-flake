{ config, lib, pkgs, userSettings, nix-doom-emacs, nix-colors, ... }:

{
  imports = [
    ./bash.nix
    ./git.nix
    ./brave.nix
    ./starship.nix
    ./gtk.nix
    ./doom.nix
    ./xcompose.nix
    ./hyprland.nix
    ./espanso.nix
    ./alacritty.nix
    #./thunderbird.nix
    ./email.nix

    # pkgs
    ./pkgs-program.nix
    ./pkgs-fonts.nix
    ./pkgs-general.nix

    # scripts
    ./bin/doomcapture.nix
    ./bin/emopicker.nix
    #./bin/wallsetter.nix
    #./bin/themechange.nix
    #./bin/theme-selector.nix

    nix-colors.homeManagerModules.default
    nix-doom-emacs.hmModule
  ];

  home = {
    username = "${userSettings.name}";
    homeDirectory = "/home/${userSettings.name}";
    stateVersion = "24.05"; # Please read the comment before changing.
    packages = with pkgs; [ ];
    file = { };
    sessionVariables = {
      EDITOR = "${userSettings.editor}";
      TERM = "${userSettings.term}";
      BROWSER = "${userSettings.browser}";
      GTK_IM_MODULE = "cedilla";
      QT_IM_MODULE = "cedilla";
    };

  };

  colorScheme = nix-colors.colorSchemes."${userSettings.theme}";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
