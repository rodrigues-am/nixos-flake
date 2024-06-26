{ pkgs, config, ... }:

{
  home.file.".config/swaylock/config".text = ''
    indicator
    ignore-empty-password
    indicator-thickness=15
    indicator-radius=150
    image=~/Pictures/Wallpapers/w1.jpg
    clock
    effect-blur=7x5
    effect-vignette=0.5:0.5
    ring-color=${config.colorScheme.palette.base0D}
    key-hl-color=${config.colorScheme.palette.base0F}
    line-color=00000000
    inside-color=00000088
    inside-clear-color=00000088
    text-color=${config.colorScheme.palette.base05}
    text-clear-color=${config.colorScheme.palette.base05}
    ring-clear-color=${config.colorScheme.palette.base0D}
    separator-color=00000000
    grace=2
    fade-in=0.5
    font=Ubuntu
  '';
}
