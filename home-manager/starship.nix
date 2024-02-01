{ config, lib, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    package = pkgs.starship;
    settings = {
      format = "[]( #${config.colorScheme.colors.base0D})  $directory()";
      directory = {
        format = "[$path]($style)[$read_only]($read_only_style) ";
        read_only = " ";
      };
      hostname = {
        ssh_only = false;
        ssh_symbol = " ";
        format = "on [$hostname](bold  #${config.colorScheme.colors.base08}) ";
        trim_at = ".local";
        disabled = false;
      };
    };
  };

}
