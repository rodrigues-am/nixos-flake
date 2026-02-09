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
      sha256 = "sha256:0ndagsvzbsjm8flph9zgnv3zvh55adjpavvvi0azysafpzdij5vr";
    }))
  ];
  services.emacs.enable = true;
}
