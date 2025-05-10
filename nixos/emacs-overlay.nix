{ pkgs, ... }: {
  services.emacs.package = pkgs.emacs30-pgtk;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:1zp8nfx9z9jp8gwxfs7asj3p9cwkkkinvz2qlwg5qravx8x1imif";
    }))
  ];
  services.emacs.enable = true;
}
