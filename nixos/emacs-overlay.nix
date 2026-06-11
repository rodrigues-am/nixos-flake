{ pkgs, ... }:

let
  myEmacs = (pkgs.emacsPackagesFor pkgs.emacs30-pgtk).emacsWithPackages (
    epkgs: with epkgs; [
      mu4e
      vterm
      nerd-icons
      pdf-tools
      geiser
      geiser-guile
      tree-sitter
    ]
  );

in
{
  environment.systemPackages = with pkgs; [ myEmacs ];
  nixpkgs.overlays = [
    (import (
      builtins.fetchTarball {
        url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
        sha256 = "sha256:1hdlfk6bpvs43pzxspzw3h03lkrq3320gs47fjrzcy17dcfdgs2l";
      }
    ))
  ];
  services.emacs.enable = true;
}
