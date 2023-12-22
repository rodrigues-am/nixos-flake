{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    darktable
    ffmpeg_6-full
    gimp-with-plugins
    imagemagick
    inkscape-with-extensions
  ];
}
