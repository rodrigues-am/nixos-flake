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
      sha256 = "sha256:180xwbl7cq0g43gsilrybisqxfm5yzb72dh10yb59v488qckwd44";
    }))
  ];
  services.emacs.enable = true;
}
