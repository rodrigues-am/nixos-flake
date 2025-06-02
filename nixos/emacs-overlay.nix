{ pkgs, ... }: {
  services.emacs.package = pkgs.emacs30-pgtk;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:1asmxr6jw6vxv271jq9p6cmd6ifs8r6jjg39v2kq4vf7y6gans38";
    }))
  ];
  services.emacs.enable = true;
}
