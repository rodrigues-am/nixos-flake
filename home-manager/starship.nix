{ config, lib, pkgs, ... }:

{
  programs.starship = {
     enable = true;
     settings = {
       format = "[](blue)  $directory(blue)";
        directory = {
         format = "[$path]($style)[$read_only]($read_only_style) ";
         read_only = " ";
       };
       hostname = {
         ssh_only = false;
         ssh_symbol = " ";
         format = "on [$hostname](bold red) ";
         trim_at = ".local";
         disabled = false;
       };
     };
   };


}
