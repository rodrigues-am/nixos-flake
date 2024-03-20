{ config, lib, pkgs, pkgs-stable, inputs, userSettings, ... }:

{
  users.users.${userSettings.name}.packages = (with pkgs; [
    darktable
    ffmpeg_6-full
    imagemagick
    inkscape-with-extensions
  ]) ++ (with pkgs-stable; [ gimp-with-plugins ]);

}
