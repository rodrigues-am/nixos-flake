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
    ./dnust.nix
    ./waybar.nix
    ./rofi.nix
    ./swaylock.nix
    ./swaync.nix
    ./hyprland.nix

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

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # hyprland
    waybar
    swaynotificationcenter
    swaylock
    rofi-wayland
    swww
    grim
    slurp
    swayidle
    wl-clipboard
    libnotify
    ydotool

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {

    # hyprland
    ".config/zaney-stinger.mov".source = ./resources/zaney-stinger.mov;
    ".emoji".source = ./resources/emoji;
    ".base16-themes".source = ./resources/base16-themes;
    ".face".source = ./resources/face.jpg;
    ".config/rofi/rofi.jpg".source = ./resources/rofi.jpg;

    # alacritty
    ".config/alacritty.toml".source = ./alacritty.toml;

    #   # espanso
    ".config/espanso/match/base.yml".source = ./espanso/match/base.yml;

    #".config/sxhkdrc".source = ./sxhkdrc;
    #  ".emacs.d/early-init.el".source =  ~/.config/emacs/early-init.el;

    #   # leftwm (window-manager)
    #  ".config/leftwm/themes.toml".source = ./leftwm/themes.toml;
    #  ".config/leftwm/config.ron".source = ./leftwm/config.ron;
    #  ".config/leftwm/themes/my-theme".source = ./leftwm/themes/my-theme;

    #   # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    #   # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    #   # # symlink to the Nix store copy.
    #   # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/andre/etc/profile.d/hm-session-vars.sh
  # if you don't want to manage your shell through Home Manager.

  home.sessionVariables = {
    EDITOR = "${userSettings.editor}";
    TERM = "${userSettings.term}";
    GTK_IM_MODULE = "cedilla";
    QT_IM_MODULE = "cedilla";

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.emacs.enable = true;

}
