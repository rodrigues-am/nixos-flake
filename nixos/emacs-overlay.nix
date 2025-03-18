{ pkgs, ... }: {
  # ...

  services.emacs.package = pkgs.emacs30-pgtk;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:12n9yshd0612gpjw3wd6x2sc70gzc2mvx525w8n819ir09a4lyz9";
    }))
  ];
  services.emacs.enable = true;
  # ...
}
