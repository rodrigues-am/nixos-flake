{ pkgs, ... }: {
  services.emacs.package = pkgs.emacs30-pgtk;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:0p10lhlrmqd4gpf0106i5j00m88ndnp4k8b2f5hfg14m9kfd2l2d";
    }))
  ];
  services.emacs.enable = true;
}
