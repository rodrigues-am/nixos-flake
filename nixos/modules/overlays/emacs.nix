{ inputs, pkgs-stable, ... }:

let
  myEmacs = (pkgs-stable.emacsPackagesFor pkgs-stable.emacs-pgtk).emacsWithPackages (
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
  environment.systemPackages = [ myEmacs ];
  nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];
  services.emacs.enable = true;
}
