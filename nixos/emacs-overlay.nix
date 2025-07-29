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
      sha256 = "sha256:16m477754hy652zkisvalxd60za0bd97q95rx0gl0w9mwfdgadic";
    }))
  ];
  services.emacs.enable = true;
}
