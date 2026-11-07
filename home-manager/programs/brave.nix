{ pkgs-brave, ... }:

{
  programs.brave = {
    enable = true;
    package = pkgs-brave.brave;
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
