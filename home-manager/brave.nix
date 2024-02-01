{ config, lib, pkgs, ... }:

{
  programs.brave = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      "ekhagklcjbdpajgpjgmbionohlpdbjgc" # zotero
      "ldipcbpaocekfooobnbcddclnhejkcpn" # google scholar
      "kbfnbcaeplbcioakkpcpgfkobkghlhen" # grammarly
    ];
  };
}
