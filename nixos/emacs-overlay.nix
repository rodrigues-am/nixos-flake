{ pkgs, ... }: {
  services.emacs.package = pkgs.emacs30-pgtk;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:0yhk188ms76fc23gabsapdx1v5r4k05dkg563vphi1mhrdzk51ny";
    }))
  ];
  services.emacs.enable = true;
}
