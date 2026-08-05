{ pkgs-stable, ... }:

{
  programs.brave = {
    enable = true;
    package = pkgs-stable.brave;
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
    ];
    extensions = [
      "ekhagklcjbdpajgpjgmbionohlpdbjgc" # zotero
      "ldipcbpaocekfooobnbcddclnhejkcpn" # google scholar
      "kbfnbcaeplbcioakkpcpgfkobkghlhen" # grammarly
    ];
  };
}
