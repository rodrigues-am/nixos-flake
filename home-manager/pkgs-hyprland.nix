{ config, lib, pkgs, pkgs-stable, inputs, ... }:

{

  home.packages = (with pkgs; [
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
    wev
    nautilus
  ]) ++ (with pkgs-stable; [ ]);

  home.file = {

    # hyprland
    ".config/zaney-stinger.mov".source = ./resources/zaney-stinger.mov;
    ".base16-themes".source = ./resources/base16-themes;
    ".face".source = ./resources/face.jpg;
    ".config/rofi/rofi.jpg".source = ./resources/rofi.jpg;

  };
}
