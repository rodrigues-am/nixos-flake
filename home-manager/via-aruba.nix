{ pkgs, ... }:

let
  arubaVia = pkgs.callPackage ./via-vpn/via.nix {
    # Se quiser, aponte explicitamente para o .deb:
    #src = ./via-vpn/via-amd64.deb;
  };
in {

  home.packages = [ arubaVia ];

  xdg.desktopEntries."aruba-via-ui" = {
    name = "Aruba VIA";
    exec = "aruba-via-ui";
    terminal = false;
    icon = "via";
    categories = [ "Network" "GTK" ];
  };
}
