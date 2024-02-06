{ config, lib, pkgs, inputs, userSettings, ... }:

{
  users.users.${userSettings.name}.packages = with pkgs; [
    darktable
    ffmpeg_6-full
    gimp-with-plugins
    imagemagick
    inkscape-with-extensions
  ];
}
