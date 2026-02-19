{ pkgs, ... }:

let
  myEmacs = (pkgs.emacsPackagesFor pkgs.emacs30-pgtk).emacsWithPackages (epkgs:
    with epkgs; [
      mu4e
      vterm
      nerd-icons
      pdf-tools
      geiser
      geiser-guile
    ]);

in {
  environment.systemPackages = with pkgs; [ myEmacs ];
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:125a6rwlsgj2gx3w5xmc4g7yr63zk63zdb0c718n61gw1jfiiwyq";
    }))
  ];
  services.emacs.enable = true;
}
