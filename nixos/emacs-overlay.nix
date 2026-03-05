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
    ]
  );

in
{
  environment.systemPackages = with pkgs; [ myEmacs ];
  nixpkgs.overlays = [
    (import (
      builtins.fetchTarball {
        url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
        sha256 = "sha256:0q2hk476hyzqfi1fhj3w74h5254gpa6lh9jv7pw0fqz1pksb2w8c";
      }
    ))
  ];
  services.emacs.enable = true;
}
