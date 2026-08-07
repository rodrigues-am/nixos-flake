{ pkgs-stable, ... }:

{
  programs.brave = {
    enable = true;
    package = pkgs-stable.brave;
    commandLineArgs = [
      "--ozone-platform=x11"
    ];
    extensions = [
      "ekhagklcjbdpajgpjgmbionohlpdbjgc" # zotero
      "ldipcbpaocekfooobnbcddclnhejkcpn" # google scholar
      "kbfnbcaeplbcioakkpcpgfkobkghlhen" # grammarly
    ];
  };
}
