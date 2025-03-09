{ pkgs, ... }: {
  # ...

  services.emacs.package = pkgs.emacs30-pgtk;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:0l0linhgvdjikhhyh7rh3ll48sb2x5sf0jr2a627qawhyjf1h7vm";
    }))
  ];
  services.emacs.enable = true;
  # ...
}
