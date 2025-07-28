{ pkgs, ... }:

let
  myEmacs = (pkgs.emacsPackagesFor pkgs.emacs30-pgtk).emacsWithPackages
    (epkgs: with epkgs; [ mu4e vterm nerd-icons pdf-tools ]);

in {
  environment.systemPackages = with pkgs; [ myEmacs ];
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:0ry2rmpghzvilhpivb7q4a0brdwrxv2937hgbsm5n78ia73c5wr6";
    }))
  ];
  services.emacs.enable = true;
}
