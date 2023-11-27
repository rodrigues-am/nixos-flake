{ config, lib, pkgs, ... }:

{
   environment.systemPackages = with pkgs; [
    # Jogos
    steam
    steam-run

   ];
}
