{ pkgs, ... }: {
  services.emacs.package = pkgs.emacs30-pgtk;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:0pcs62ysrnjm0j5vfp1vpky83y8lykyp5qlx41blwfhw3rrds1pw";
    }))
  ];
  services.emacs.enable = true;
}
