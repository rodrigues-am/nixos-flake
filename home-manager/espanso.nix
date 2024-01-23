{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [ espanso espanso-wayland ];

  home.file = {
    # espanso
    ".config/espanso/match/base.yml".source = ./espanso/match/base.yml;
  };

  services.espanso.enable = true;
}
