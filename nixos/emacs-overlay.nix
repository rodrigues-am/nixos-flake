{ pkgs, ... }: {
  services.emacs.package = pkgs.emacs30-pgtk;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:1ncz0sh5yj752s94g2mk0jvglz74ykr5fyxmjfx9gmg1vn3vcps1";
    }))
  ];
  services.emacs.enable = true;
}
