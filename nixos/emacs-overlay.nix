{ pkgs, ... }: {
  # ...

  services.emacs.package = pkgs.emacs30-pgtk;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:1n7nmdz3z5mzl6qnj74n45pqzjx55nsx5zark7glcw83rn76a12i";
    }))
  ];
  services.emacs.enable = true;
  # ...
}
