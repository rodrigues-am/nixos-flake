{ pkgs, pkgs-stable, ... }:

{

  home.packages =
    (with pkgs; [
      swaynotificationcenter
      awww
      grim
      slurp
      swayidle
      wl-clipboard
      libnotify
      ydotool
      xhost
      wev
      nautilus
      hyprlock
    ])
    ++ (with pkgs-stable; [ ]);

  home.file = {

    # hyprland
    ".config/zaney-stinger.mov".source = ./resources/zaney-stinger.mov;
    ".base16-themes".source = ./resources/base16-themes;
    ".face".source = ./resources/face.jpg;
    ".config/rofi/rofi.jpg".source = ./resources/rofi-gruvbox.jpg;

  };
}
