{ config, lib, pkgs, ... }:

{

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

  home.file = {

    # hyprland
    ".config/zaney-stinger.mov".source = ./resources/zaney-stinger.mov;
    ".emoji".source = ./resources/emoji;
    ".base16-themes".source = ./resources/base16-themes;
    ".face".source = ./resources/face.jpg;
    ".config/rofi/rofi.jpg".source = ./resources/rofi.jpg;

  };

}
