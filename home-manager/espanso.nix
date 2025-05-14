{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs;
    [
      #espanso
      #espanso-wayland
    ];

  home.file = {
    # espanso
    ".config/espanso/match/base.yml".source = ./espanso/match/base.yml;
    #".config/espanso/config/default.yml".source = ./espanso/config/default.yml;
  };

  services.espanso = {
    enable = true;
    configs = {
      default = {
        disable_x11_fast_inject = true;
        backend = "inject";

      };
    };
  };
}
