{ pkgs, lib, ... }:

{
  home.file = {
    ".config/espanso/match/base.yml".source = ./espanso/match/base.yml;
  };
  # 2) Forçar o ExecStart do unit a usar o espanso-wayland
  #
  #  systemd.user.services.espanso.Service.ExecStart = lib.mkForce "${pkgs.espanso-wayland}/bin/espanso launcher";

  services.espanso = {
    waylandSupport = true; # habilita Wayland
    x11Support = false; # opcional, desabilita X11
    package-wayland = pkgs.espanso-wayland; # use o pacote wayland
    package = pkgs.espanso-wayland;
    enable = true;
    configs = {
      default = {
        #  disable_x11_fast_inject = true;
        backend = "auto"; # tenta Inject e cai p/ Clipboard se precisar
        keyboard_layout = {
          layout = "us";
          variant = "altgr-intl"; # <- chave para US Alt-International
        };
      };
    };
  };
}
