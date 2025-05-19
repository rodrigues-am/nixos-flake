{ pkgs, ... }: {
  services.emacs.package = pkgs.emacs30-pgtk;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:122i0zrzdfxhj92ppa9m1vmqs3vjz8qkjs04iqi1k58qbjl69lmi";
    }))
  ];
  services.emacs.enable = true;
}
