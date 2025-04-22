{ pkgs-stable, ... }:

{
  programs.brave = {
    enable = true;
    package = pkgs-stable.brave;
    extensions = [
      "ekhagklcjbdpajgpjgmbionohlpdbjgc" # zotero
      "ldipcbpaocekfooobnbcddclnhejkcpn" # google scholar
      "kbfnbcaeplbcioakkpcpgfkobkghlhen" # grammarly
    ];
  };
}
