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
      sha256 = "sha256:1b6gqwi2xlcg14384wn937ckncxvxkfb8ry3qq0y50ahj4zbfpzd";
    }))
  ];
  services.emacs.enable = true;
}
