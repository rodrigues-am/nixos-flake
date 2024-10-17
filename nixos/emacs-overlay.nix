{ config, pkgs, callPackage, ... }: {
  # ...

  services.emacs.package = pkgs.emacs30-pgtk;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    }))
  ];
  services.emacs.enable = true;
  # ...
}
