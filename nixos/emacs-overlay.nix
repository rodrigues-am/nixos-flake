{ pkgs, ... }: {
  services.emacs.package = pkgs.emacs30-pgtk;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:1xak0y5f6mwndgzcg9w48xkzrd3j0kdyac4m3gki8l9bxlgwnkbq";
    }))
  ];
  services.emacs.enable = true;
}
