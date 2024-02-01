{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [
    # hyprland
    swaynotificationcenter
    swaylock
    swww
    grim
    slurp
    swayidle
    wl-clipboard
    libnotify
    ydotool
    xorg.xhost
    gnome.nautilus
  ];

  home.file = {

    # hyprland
    ".config/zaney-stinger.mov".source = ./resources/zaney-stinger.mov;
    ".base16-themes".source = ./resources/base16-themes;
    ".face".source = ./resources/face.jpg;
    ".config/rofi/rofi.jpg".source = ./resources/rofi.jpg;

  };

}
