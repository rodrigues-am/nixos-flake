{ pkgs, ... }: {
  # ...

  services.emacs.package = pkgs.emacs30-pgtk;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:0k5sl1zhdn0pvkrwddwc217hrmx4wcfb3wgp0154japa3c5mm8kr";
    }))
  ];
  services.emacs.enable = true;
  # ...
}
